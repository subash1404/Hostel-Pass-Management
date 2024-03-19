const mongoose = require("mongoose");
const schema = mongoose.Schema;

const QrSchema = new schema(
  {
    qrId: {
      type: String,
      required: true,
    },
    passId: {
      type: String,
      required: true,
    },
    studentId: {
      type: String,
      required: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("qrs", QrSchema);
