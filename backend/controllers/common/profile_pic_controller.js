const express = require("express");
const BugReport = require("../../models/bug_report_model");
const router = express.Router();

router.get("/fetch", (req, res, next) => {
  try {
    // const photoFilePath = path.join(
    //   __dirname +
    //     "../../../images/profiles/" +
    //     req.body.USER_role +
    //     "/" +
    //     student.studentId +
    //     ".jpg"
    // );

    const photoBuffer = fs.readFileSync(photoFilePath);
    const profileBuffer = photoBuffer.toString("base64");
  } catch {
    res.status(400).json({ message: "Internal Server Error" });
  }
});

router.get("/:studentId/fetch", (req, res, next) => {
  try {
  } catch {
    res.status(400).json({ message: "Internal Server Error" });
  }
});

module.exports = router;
