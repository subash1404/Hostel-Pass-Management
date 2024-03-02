const mongoose = require("mongoose");

const bugReportSchema = mongoose.Schema(
  {
    uid: { type: String, required: true },
    username: { type: String, required: true },
    role: { type: String, required: true },
    report: { type: String, required: true },
  },
  { timestamps: true }
);

module.exports = mongoose.model("bug_reports", bugReportSchema);
