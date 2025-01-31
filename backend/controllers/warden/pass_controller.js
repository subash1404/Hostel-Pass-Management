const express = require("express");
const router = express.Router();
const Student = require("../../models/student_model");
const Pass = require("../../models/pass_model");
const {aesEncrypt, aesDecrypt} = require("../../utils/aes");


router.get("/getPass", async (req, res) => {
    try {
        const allStudents = await Student.find({});

        let passes = [];
        for (const student of allStudents) {
            const studentPasses = await Pass.find({
                studentId: student.studentId,
                // isSpecialPass: true,
            });

            for (const pass of studentPasses) {
                passes.push({
                    ...pass._doc,
                    studentName: student.username,
                    gender: student.gender,
                    dept: student.dept,
                    fatherPhNo: student.fatherPhNo,
                    motherPhNo: student.motherPhNo,
                    phNo: student.phNo,
                    blockNo: student.blockNo,
                    roomNo: student.roomNo,
                    year: student.year,
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
                });
            }
        }

        function getEndOfDay(date) {
            const endOfDay = new Date(date);
            endOfDay.setHours(23, 59, 59, 999);
            return endOfDay;
        }

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
                //         console.log("rt");
                //         await Pass.findOneAndUpdate(
                //             {passId: pass.passId},
                //             {isActive: false, status: "Expired"}
                //         );
                //         return false;
                //     }
                // }
            }
            return true;
        });

        passes.sort((a, b) => {
            return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
        });

        res.json(passes);
    } catch (error) {
        res.status(500).json({message: "Internal Server Error"});
    }
});


router.post("/approvePass", async (req, res) => {
    try {
        const {passId, wardenName, confirmedWith} = req.body;
        const pass = await Pass.findOneAndUpdate(
            {passId: passId},
            {status: "Approved", approvedBy: wardenName, confirmedWith: confirmedWith},
            {new: true}
        );
        if (!pass) {
            return res.status(404).json({message: "Pass not found"});
        }
        res.json(pass);
    } catch (error) {
        console.error("Error approving pass:", error);
        res.status(500).json({message: "Internal Server Error"});
    }
});

router.post("/rejectPass", async (req, res) => {
    try {
        const {passId, wardenName} = req.body;
        const pass = await Pass.findOneAndUpdate(
            {passId: passId},
            {status: "Rejected", isActive: false, approvedBy: wardenName, confirmedWith: "None"},
            {new: true}
        );
        if (!pass) {
            return res.status(404).json({message: "Pass not found"});
        }
        res.json(pass);
    } catch (error) {
        console.error("Error rejecting pass:", error);
        res.status(500).json({message: "Internal Server Error"});
    }
});

module.exports = router;
