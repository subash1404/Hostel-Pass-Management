const express = require("express");
const router = express.Router();
const Student = require("../../models/student_model");

router.get("/getStudents", async (req, res, next) => {
  try {
    const filteredStudents = await Student.find({ blockNo: req.body.USER_permanentBlock });
    res.json(filteredStudents);
  } catch (e) {
    console.log(e);
    res.status(400).json({ message: "Internal Server Error" });
  }
});

module.exports = router;
