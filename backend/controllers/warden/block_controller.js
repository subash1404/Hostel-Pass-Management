const express = require("express");
const path = require("path");
const fs = require("fs");
const router = express.Router();
const Student = require("../../models/student_model");

router.get("/getStudents", async (req, res, next) => {
  try {
    const filteredStudents = await Student.find({
    });
    
    let blockStudents = [];
    
    for (const student of filteredStudents) {
      blockStudents.push({
        ...student._doc,
        email: student._doc.studentId + "@svce.ac.in",
      });
    }
      
      console.log(blockStudents);
      res.json(blockStudents);
  } catch (e) {
    console.log(e);
    res.status(400).json({ message: "Internal Server Error" });
  }
});

module.exports = router;
