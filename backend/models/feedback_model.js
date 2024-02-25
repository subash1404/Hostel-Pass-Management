const mongoose = require("mongoose");

const feedbackSchema = mongoose.Schema(
  {
    uid: { type: String, required: true },
    username: { type: String, required: true },
    role: { type: String, required: true },
    rating: { type: Number, required: true },
    feedback: { type: String, required: true },
  },
  { timestamps: true }
);

module.exports = mongoose.model("feedbacks", feedbackSchema);
