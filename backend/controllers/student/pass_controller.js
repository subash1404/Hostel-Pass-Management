const express = require("express");
const bcrypt = require("bcrypt");
const router = express.Router();
const jwt = require("jsonwebtoken");
const User = require("../../models/user_model");
const Pass = require("../../models/pass_model");
const QR = require("../../models/qr_model");
const Student = require("../../models/student_model");
const { v4: uuidv4 } = require("uuid");
const { aesEncrypt, aesDecrypt } = require("../../utils/aes");

router.get("/getPass", async (req, res) => {
    try {
        const student = await Student.findOne({
            studentId: req.body.USER_studentId,
        });

        const passes = await Pass.find({
            studentId: req.body.USER_studentId,
        }).lean();


        function getEndOfDay(date) {
            const endOfDay = new Date(date);
            endOfDay.setHours(23, 59, 59, 999);
            return endOfDay;
        }

        let expiredPasses = [];

        passes.filter(async (pass) => {
            if (pass.isActive) {
                pass.qrId = aesEncrypt(pass.qrId, process.env.AES_KEY);
                // if (pass.status === "Approved" || pass.status === "Pending") {
                //     const expectedOutTime = new Date(pass.expectedOut).getTime();
                //     const qrEndTime = getEndOfDay(expectedOutTime).getTime();
                //     // console.log(Date.now());
                //     // console.log(qrEndTime);
                //     // const timestamp = 1715192999999;
                //     // const date = new Date(timestamp);
                //     // console.log(date.toString());
                //     if (Date.now() > qrEndTime) {
                //         pass.isActive = false;
                //         pass.status = "Expired";
                //         // pass.save();
                //         console.log("Hellooooo");
                //         await Pass.findOneAndUpdate(
                //             { passId: pass.passId },
                //             { isActive: false, status: "Expired" }
                //         );
                //         return false;
                //     }
                // }
            }
            return true;
        });

        passes.forEach((pass) => {
            pass.gender = student.gender;
        });

        let finalPasses = [];
        passes.forEach((pass) => {
            finalPasses.push({
                ...pass,
                isLate:
                    pass.type === "GatePass"
                        ? new Date(pass.entryScanAt).getTime() >
                        new Date(pass.expectedIn).getTime() + 60 * 60000
                        : new Date().getTime() >
                        getEndOfDay(pass.expectedIn).getTime(),
                isExceeding:
                    pass.type === "GatePass"
                        ? new Date().getTime() >
                        new Date(pass.expectedIn).getTime() + 3 * 60 * 60000
                        : new Date().getTime() >
                        getEndOfDay(pass.expectedIn).getTime(),
                showQr: pass.status === "In use"
                    ? true
                    : new Date(pass.expectedOut).getTime() + 24 * 60 * 60000 > Date.now() &&
                    new Date(pass.expectedOut).getTime() - 180 * 60000 < Date.now(),

            });
        });

        finalPasses.sort((a, b) => {
            return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
        });

        res.json({ data: finalPasses });
        // console.log(finalPasses);
    } catch (error) {
        res.status(500).json({ message: "Internal Server Error" });
    }
});

router.post("/newPass", async (req, res) => {
    try {
        const {
            studentId,
            destination,
            type,
            reason,
            inDateTime,
            outDateTime,
            isSpecialPass,
        } = req.body;

        const passId = "pass_" + uuidv4();
        const qrId = "qr_" + uuidv4();

        const anyCurrentActivePass = await Pass.findOne({
            studentId: req.body.USER_studentId,
            isActive: true,
        });

        if (anyCurrentActivePass) {
            res.status(400).json({
                message: `Active pass already exist`,
            });
            return;
        }

        const oldPasses = await Pass.find({
            studentId: req.body.USER_studentId,
            status: "Used",
            isActive: false,
        });

        var oldPassCount = 0;

        if (!isSpecialPass) {
            oldPasses.forEach((oldPass) => {
                if (
                    new Date(oldPass.expectedOut).getMonth() ===
                    new Date(outDateTime).getMonth() &&
                    !oldPass.isSpecialPass
                ) {
                    oldPassCount += 1;
                }
            });
        }

        if (oldPassCount >= parseInt(process.env.PASS_LIMIT)) {
            res.status(400).json({
                message: `Passes allocated for this month are over. Please apply for a special pass`,
            });
            return;
        }

        await new QR({ passId, qrId, studentId }).save();
        const student = await Student.findOne({
            studentId: req.body.USER_studentId,
        });
        console.log(student);

        const pass = await new Pass({
            uid: req.body.USER_uid,
            passId,
            destination,
            type,
            reason,
            expectedIn: inDateTime,
            expectedOut: outDateTime,
            studentId,
            isActive: true,
            qrId,
            status: "Pending",
            isSpecialPass,
        }).save();

        res.json({
            passId: pass.passId,
            qrId: aesEncrypt(pass.qrId, process.env.AES_KEY),
            destination: pass.destination,
            reason: pass.reason,
            gender: student.gender,
            isActive: pass.isActive,
            status: pass.status,
            type: pass.type,
            isSpecialPass: pass.isSpecialPass,
        });
    } catch (e) {
        console.log(e);
        res.status(500).json({ message: "Internal Server Error" });
    }
});

router.delete("/deletePass/:passId", async (req, res) => {
    try {
        const passId = req.params.passId;
        let pass = await Pass.findOne({ passId: passId });
        if (pass.status == "In use" || pass.status == "Used") {
            res.status(400).json({ message: "Cannot delete In use pass" });
            console.log("cannot delete pass");
            return;
        }
        await Pass.deleteOne({ passId: passId });
        res.json({ message: "Pass deleted Successfully" });
    } catch (err) {
        console.log(err);
        res.status(500).json("Internal Server Error");
    }
});

module.exports = router;
