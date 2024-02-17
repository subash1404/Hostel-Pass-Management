const mongoose = require("mongoose");
const schema = mongoose.Schema;

const PassSchema = new schema(
  {
    passId: {
      type: String,
      required: true,
    },
    studentId: {
      type: String,
      required: true,
    },
    type: {
      type: String,
      required: true,
      emum: ["Gatepass", "Staypass"],
    },
    reason: {
      type: String,
      required: true,
    },
    status: {
      type: String,
      required: true,
      enum: ["Pending", "Approved", "Rejected", "Expired", "Deleted", "Completed"],
    },
    destination: {
      type: String,
      required: true,
    },
    isActive: {
      type: Boolean,
      required: true,
    },
    approvedBy: {
      type: String,
    },
    scannedBy: {
      type: String,
    },
    expectedExitTime: {
      type: String,
      required: true,
    },
    actualExitTime: {
      type: String,
    },
    expectedEntryTime: {
      type: String,
      required: true,
    },
    actualEntryTime: {
      type: String,
    },
    expectedExitDate: {
      type: String,
      required: true,
    },
    actualExitDate: {
      type: String,
    },
    expectedEntryDate: {
      type: String,
      required: true,
    },
    actualEntryDate: {
      type: String,
    },
    isEntryLate: {
      type: Boolean,
    },
    lateReason: {
      type: String,
    },
    qrId: {
      type: String,
      required: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("passes", PassSchema);
