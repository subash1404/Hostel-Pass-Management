const express = require("express");
const router = express.Router();
const Announcement = require("../../models/announcement_model");

router.get("/getAnnouncement/:blockNo", async (req, res) => {
  try {
    const blockNo = req.params.blockNo;
    const announcement = await Announcement.find({ blockNo: blockNo });
    res.json(announcement);
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: "Internal server error" });
  }
});
module.exports = router;
