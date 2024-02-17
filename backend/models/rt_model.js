const mongoose = require("mongoose");
const schema = mongoose.Schema;
const { v4: uuidv4 } = require("uuid");

const RtSchema = new schema(
  {
    rtId: {
      type: String,
      required: true,
      default: "rt_" + uuidv4(),
    },
    uid: {
      type: String,
      required: true,
    },
    name: {
      type: String,
      required: true,
    },
    photoPath: {
      type: String,
      required: true,
    },
    email: {
      type: String,
    },
    block: {
      type: Number,
      required: true,
    },
    phno: {
      type: String,
      required: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("rts", RtSchema);
