const express = require("express");
const Feedback = require("../../models/feedback_model");
const router = express.Router();

router.post("/newFeedback", (req, res, next) => {
  try {
    const { rating, feedback } = req.body;
    new Feedback({
      uid: req.body.USER_uid,
      role: req.body.USER_role,
      username: req.body.USER_username, 
      feedback: feedback,
      rating: rating
    }).save();
    res.json({ message: "Your feedback recorded successfully" });
  } catch {
    res.status(400).json({ message: "Internal Server Error" });
  }
});

module.exports = router;
