const express = require("express");
const bcrypt = require("bcrypt");
const router = express.Router();
const jwt = require("jsonwebtoken");
const User = require("../../models/user_model");
const Pass = require("../../models/pass_model");
const QR = require("../../models/qr_model");
const Student = require("../../models/student_model");
const { v4: uuidv4 } = require("uuid");
const { aesEncrypt, aesDecrypt } = require("../../utils/aes");

router.get("/getPass", async (req, res) => {
  try {
    const passes = await Pass.find({ studentId: req.body.USER_studentId });
    passes.forEach((pass) => {
      if (pass.isActive) {
        pass.qrId = aesEncrypt(pass.qrId, process.env.AES_KEY);
      }
    });
    res.json({ data: passes });
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
});

router.post("/newPass", async (req, res) => {
  try {
    const {
      studentId,
      destination,
      type,
      reason,
      inDateTime,
      outDateTime,
      isSpecialPass,
    } = req.body;

    const passId = "pass_" + uuidv4();
    const qrId = "qr_" + uuidv4();

    await new QR({ passId, qrId, studentId }).save();

    const pass = await new Pass({
      uid: req.body.USER_uid,
      passId,
      destination,
      type,
      reason,
      expectedIn: inDateTime,
      expectedOut: outDateTime,
      studentId,
      isActive: true,
      qrId,
      status: "Pending",
      isSpecialPass,
    }).save();

    res.json({
      passId: pass.passId,
      qrId: aesEncrypt(pass.qrId, process.env.AES_KEY),
      destination: pass.destination,
      reason: pass.reason,
      isActive: pass.isActive,
      status: pass.status,
      type: pass.type,
      isSpecialPass: pass.isSpecialPass,
    });
  } catch (e) {
    console.log(e);
    res.status(500).json({ message: "Internal Server Error" });
  }
});

router.delete("/deletePass/:passId", async (req, res) => {
  try{
    const passId = req.params.passId;
    await Pass.deleteOne({passId:passId});
    res.json({message:"Pass deleted Successfully"});
  }catch(err){
    console.log(err);
    res.status(500).json("Internal Server Error");
  }
});

module.exports = router;
