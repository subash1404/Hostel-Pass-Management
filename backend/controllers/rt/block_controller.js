const express = require("express");
const path = require("path");
const fs = require("fs");
const router = express.Router();
const Student = require("../../models/student_model");
const Announcement = require("../../models/announcement_model");

router.get("/getStudents", async (req, res, next) => {
  try {
    const filteredStudents = await Student.find({
      blockNo: req.body.USER_permanentBlock,
    });
    console.log(req.body.USER_permanentBlock);

    let blockStudents = [];

    for (const student of filteredStudents) {
      const photoFilePath = path.join(
        __dirname + "../../../images/profiles/students/" + "2021it0668" + ".jpg"
      );

      const photoBuffer = fs.readFileSync(photoFilePath);
      const profileBuffer = photoBuffer.toString("base64");
      blockStudents.push({ ...student._doc, profileBuffer });
    }


    console.log(blockStudents);
    res.json(blockStudents);
  } catch (e) {
    console.log(e);
    res.status(400).json({ message: "Internal Server Error" });
  }
});

router.post('/postAnnouncement',async (req,res) => {
  try{
    const {title,message,blockNo,rtId} = req.body;
    const announcement = await new Announcement({title:title,message:message,blockNo:blockNo,rtId:rtId}).save();
    res.json({
      _id: announcement._id,
      rtId: announcement.rtId,
      title: announcement.title,
      blockNo: announcement.blockNo,
      message: announcement.message,
    });
  }catch(err){
    console.log(err);
    res.status(500).json({message:"Internal server error"});
  }
});
router.get('/getAnnouncement/:blockNo',async (req,res) => {
  try{
    const blockNo = req.params.blockNo;
    const announcement = await Announcement.find({blockNo:blockNo});
    console.log(announcement);
    res.json(announcement);
  }catch(err){
    console.log(err);
    res.status(500).json({message:"Internal server error"});
  }
});
router.delete('/deleteAnnouncement/:announcementId',async (req,res) => {
  try{
    const annoucementId = req.params.announcementId;
    const announcement = await Announcement.findOneAndDelete({_id:annoucementId});
    res.json(announcement);
  }catch(err){
    console.log(err);
    res.status(500).json({message:"Internal server error"});
  }
});
module.exports = router;
