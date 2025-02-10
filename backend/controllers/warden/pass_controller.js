const express = require("express");
const router = express.Router();
const Student = require("../../models/student_model");
const Pass = require("../../models/pass_model");
const {aesEncrypt, aesDecrypt} = require("../../utils/aes");


router.get("/getPass", async (req, res) => {
    try {
        const passes = await Pass.aggregate([
            {
                $lookup: {
                    from: "students",
                    localField: "studentId",
                    foreignField: "studentId",
                    as: "studentInfo",
                },
            },
            {
                $unwind: "$studentInfo",
            },
        ]);

        const currentTime = Date.now();
        const updatedPasses = [];

        for (const pass of passes) {
            const isLate =
                pass.type === "GatePass"
                    ? new Date(pass.entryScanAt).getTime() >
                    new Date(pass.expectedIn).getTime() + 60 * 60000
                    : currentTime > getEndOfDay(pass.expectedIn).getTime();

            const isExceeding =
                pass.type === "GatePass"
                    ? currentTime > new Date(pass.expectedIn).getTime() + 3 * 60 * 60000
                    : currentTime > getEndOfDay(pass.expectedIn).getTime();

            if (pass.isActive) {
                if (pass.status === "Approved" || pass.status === "Pending") {
                    const qrEndTime = getEndOfDay(new Date(pass.expectedOut)).getTime();
                    if (currentTime > qrEndTime) {
                        pass.isActive = false;
                        pass.status = "Expired";
                        await Pass.findOneAndUpdate(
                            { passId: pass.passId },
                            { isActive: false, status: "Expired" }
                        );
                    }
                }
            }

            updatedPasses.push({
                ...pass,
                studentName: pass.studentInfo.username,
                gender: pass.studentInfo.gender,
                dept: pass.studentInfo.dept,
                fatherPhNo: pass.studentInfo.fatherPhNo,
                motherPhNo: pass.studentInfo.motherPhNo,
                phNo: pass.studentInfo.phNo,
                blockNo: pass.studentInfo.blockNo,
                roomNo: pass.studentInfo.roomNo,
                year: pass.studentInfo.year,
                isLate,
                isExceeding,
            });
        }

        updatedPasses.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

        res.json(updatedPasses);
    } catch (error) {
        res.status(500).json({ message: "Internal Server Error" });
    }

    function getEndOfDay(date) {
        const endOfDay = new Date(date);
        endOfDay.setHours(23, 59, 59, 999);
        return endOfDay;
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
