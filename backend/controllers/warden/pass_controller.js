const express = require("express");
const router = express.Router();
const Student = require("../../models/student_model");
const Pass = require("../../models/pass_model");

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
          dept: student.dept,
          fatherPhNo: student.fatherPhNo,
          motherPhNo: student.motherPhNo,
          phNo: student.phNo,
          blockNo:student.blockNo,
          roomNo: student.roomNo,
          year: student.year,
        });
      }
    }
    res.json(passes);
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
});


router.post("/approvePass/:passId", async (req, res) => {
  try {
    const passId = req.params.passId;
    const pass = await Pass.findOneAndUpdate(
      { passId: passId },
      { status: "Approved" },
      { new: true }
    );
    if (!pass) {
      return res.status(404).json({ message: "Pass not found" });
    }
    res.json(pass);
  } catch (error) {
    console.error("Error approving pass:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
});

router.post("/rejectPass/:passId", async (req, res) => {
  try {
    const passId = req.params.passId;
    const pass = await Pass.findOneAndUpdate(
      { passId: passId },
      { status: "Rejected", isActive: false },
      { new: true }
    );
    if (!pass) {
      return res.status(404).json({ message: "Pass not found" });
    }
    res.json(pass);
  } catch (error) {
    console.error("Error rejecting pass:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
});

module.exports = router;
