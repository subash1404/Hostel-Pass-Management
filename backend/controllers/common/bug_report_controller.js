const express = require("express");
const BugReport = require("../../models/bug_report_model");
const router = express.Router();

router.post("/newReport", (req, res, next) => {
  try {
    const { report } = req.body;
    new BugReport({
      uid: req.body.USER_uid,
      role: req.body.USER_role,
      username: req.body.USER_username, 
      report: report,
    }).save();
    res.json({ message: "Bug Report Submitted Successfully!" });
  } catch {
    res.status(400).json({ message: "Internal Server Error" });
  }
});

module.exports = router;
