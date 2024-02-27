const express = require("express");
const router = express.Router();
const Student = require("../../models/student_model");

router.get("/:blockNo/getStudents", async (req, res, next) => {
  console.log("hehe");
  const { blockNo } = req.params;
  try {
    const filteredStudents = await Student.find({ block: blockNo });
    res.json(filteredStudents);
  } catch (e) {
    console.log(e);
    res.status(400).json({ message: "Internal Server Error" });
  }
});

module.exports = router;
