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
      inDate,
      inTime,
      outDate,
      outTime,
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
      expectedInTime: inTime,
      expectedInDate: inDate,
      expectedOutTime: outTime,
      expectedOutDate: outDate,
      studentId,
      isActive: true,
      qrId,
      status: "pending",
    }).save();

    res.json({
      passId: pass.passId,
      encQrId: aesEncrypt(pass.qrId, process.env.AES_KEY),
      destination: pass.destination,
      reason: pass.reason,
      isActive: pass.isActive,
      inTime: pass.expectedInTime,
      inDate: pass.expectedInDate,
      outTime: pass.expectedOutTime,
      outDate: pass.expectedOutDate,
      status: pass.status,
      type: pass.type,
    });
  } catch (e) {
    console.log(e);
    res.status(500).json({ message: "Internal Server Error" });
  }
});

router.delete("/deletePass", async (req, res) => {});

module.exports = router;
