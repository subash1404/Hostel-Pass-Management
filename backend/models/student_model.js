const mongoose = require("mongoose");
const schema = mongoose.Schema;

const StudentSchema = new schema(
  {
    studentid: {
      type: String,
      required: true,
    },
    name: {
      type: String,
      required: true,
    },
    regNo: {
      type: String,
      required: true,
    },
    photoPath: {
      type: String,
      required: true,
    },
    uid: {
      type: String,
      required: true,
    },
    phno: {
      type: String,
      required: true,
    },
    fatherName: {
      type: String,
      required: true,
    },
    motherName: {
      type: String,
      required: true,
    },
    fatherphno: {
      type: String,
      required: true,
    },
    motherphno: {
      type: String,
      required: true,
    },
    dept: {
      type: String,
      required: true,
    },
    year: {
      type: String,
      required: true,
    },
    section: {
      type: String,
      required: true,
    },
    block: {
      type: Number,
      required: true,
    },
    roomNo: {
      type: Number,
      required: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("students", StudentSchema);
