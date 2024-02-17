const express = require("express");
const bcrypt = require("bcrypt");
const router = express.Router();
const jwt = require("jsonwebtoken");
const User = require("../models/user_model");
const Pass = require("../models/pass_model");
const QR = require("../models/qr_model");
const Student = require("../models/student_model");
const { v4: uuidv4 } = require("uuid");
const { aesEncrypt, aesDecrypt } = require("../utils/aes");

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
      passId,
      destination,
      type,
      reason,
      expectedEntryTime: inTime,
      expectedEntryDate: inDate,
      expectedExitTime: outTime,
      expectedExitDate: outDate,
      studentId,
      isActive: true,
      qrId,
      status: "Pending",
    }).save();

    res.json({
      passId: pass.passId,
      encQrId: aesEncrypt(pass.qrId, process.env.AES_KEY),
      destination: pass.destination,
      reason: pass.reason,
      isActive: pass.isActive,
      inTime: pass.expectedEntryTime,
      inDate: pass.expectedEntryDate,
      outTime: pass.expectedExitTime,
      outDate: pass.expectedExitDate,
      status: pass.status,
      type: pass.type,
    });
  } catch (e) {
    console.log(e);
    res.status(500).json({ message: "Internal Server Error" });
  }
});

module.exports = router;
