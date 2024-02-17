const mongoose = require("mongoose");
const schema = mongoose.Schema;

const UserSchema = new schema(
  {
    uid: {
      type: String,
      // required: true,
    },
    username: {
      type: String,
      // required: true,
    },
    email: {
      type: String,
      // required: true,
    },
    password: {
      type: String,
      // required: true,
    },
    role: {
      type: String,
      // required: true,
      enum: ["Student", "RT", "Warden", "Security"],
    },
    otpSecret: {
      type: String,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("users", UserSchema);
