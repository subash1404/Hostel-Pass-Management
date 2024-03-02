const express = require("express");
const path = require("path");
const fs = require("fs");
const router = express.Router();
const Student = require("../../models/student_model");

router.get("/getStudents", async (req, res, next) => {
  try {
    const filteredStudents = await Student.find({
      blockNo: req.body.USER_permanentBlock,
    });

    let blockStudents = [];

    for (const student of filteredStudents) {
      const photoFilePath = path.join(
        __dirname + "../../../images/profiles/students/" + "2021it0668" + ".jpg"
      );

      const photoBuffer = fs.readFileSync(photoFilePath);
      const profileBuffer = photoBuffer.toString("base64");
      blockStudents.push({ ...student._doc, profileBuffer });
    }


    console.log(blockStudents);
    res.json(blockStudents);
  } catch (e) {
    console.log(e);
    res.status(400).json({ message: "Internal Server Error" });
  }
});

module.exports = router;
