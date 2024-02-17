const express = require("express");
const bcrypt = require("bcrypt");
const router = express.Router();
const jwt = require("jsonwebtoken");
const User = require("../models/user_model");
const nodemailer = require("nodemailer");
const speakeasy = require("speakeasy");
require("dotenv").config();
const { v4: uuidv4 } = require("uuid");
const Student = require("../models/student_model");

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL,
    pass: process.env.PASSWD,
  },
});

// router.get("/dummy", async (req, res) => {
//   const uid = "user_" + uuidv4();
//   try {
//     await new User({
//       username: "Naveen",
//       email: "naveen.akash0904@gmail.com",
//       password: "$2b$10$sW1Ay1MBfv7/Tv33C4bdaOmvPTP3Vd/LFah/Dw2XDqfEBX2ZCoLRK",
//       uid: uid,
//       role: "Student",
//     }).save();

//     await new Student({
//       block: 3,
//       dept: "Information Technology",
//       fatherName: "Kamal",
//       motherName: "Priya",
//       fatherPhNo: "1234567890",
//       motherPhNo: "0987654321",
//       name: "Naveen",
//       uid: uid,
//       phNo: "6789054321",
//       photoPath: "/sd/sd/sd",
//       regNo: "2127210801066",
//       roomNo: 312,
//       section: "B",
//       studentId: "2021it0668",
//       year: 3,
//     }).save();
    
//     res.send();
//   } catch (e) {
//     res.status(500).send();
//   }
// });

router.post("/login", async (req, res) => {
  const { email, password } = req.body;

  const user = await User.findOne({ email });
  if (!user) {
    return res.status(401).json({ message: "User not found" });
  }

  const student = await Student.findOne({ uid: user.uid });

  const isValidPassword = await bcrypt.compare(password, user.password);
  if (!isValidPassword) {
    return res.status(401).json({ message: "Invalid Credentials" });
  }

  const jwtToken = jwt.sign(
    { id: user._id, email: user.email },
    process.env.JWT_KEY
  );

  res.json({
    jwtToken,
    uid: user.uid,
    studentId: student.studentId,
    email: user.email,
    name: user.username,
    role: user.role,
    phno: student.phNo,
    block: student.block,
    dept: student.dept,
    fatherName: student.fatherName,
    motherName: student.motherName,
    fatherphno: student.fatherPhNo,
    motherphno: student.motherPhNo,
    regNo: student.regNo,
    year: student.year,
    section: student.section,
    roomNo: student.roomNo,
    photoPath: student.photoPath,
  });
});

router.post("/forgotPassword", async (req, res) => {
  try {
    const { email } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    if (!user.otpSecret) {
      const otpSecret = speakeasy.generateSecret().base32;
      user.otpSecret = otpSecret;
      await user.save();
    }
    // Generate OTP
    const otp = speakeasy.totp({
      secret: user.otpSecret,
      encoding: "base32",
    });

    const mailOptions = {
      from: process.env.EMAIL,
      to: user.email,
      subject: "Password Reset OTP",
      html: `<h1 style={color: blue;}>Your OTP for password reset is: ${otp}</h1>`,
    };

    await transporter.sendMail(mailOptions);

    res.json({ message: "OTP sent successfully" });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

router.post("/verifyOtp", async (req, res) => {
  try {
    const { email, otp } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    if (!user.otpSecret) {
      return res.status(400).json({ message: "OTP secret not found" });
    }

    const isValidOTP = speakeasy.totp.verify({
      secret: user.otpSecret,
      encoding: "base32",
      token: otp,
      window: 6,
    });

    if (!isValidOTP) {
      return res.status(401).json({ message: "Invalid OTP" });
    }

    res.json({ message: "OTP verified successfully" });
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
});

router.post("/resetPassword", async (req, res) => {
  try {
    const { email, otp, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    if (!user.otpSecret) {
      return res.status(400).json({ message: "OTP secret not found" });
    }

    const isValidOTP = speakeasy.totp.verify({
      secret: user.otpSecret,
      encoding: "base32",
      token: otp,
      window: 6,
    });
    if (!isValidOTP) {
      return res.status(401).json({ message: "Invalid OTP" });
    }

    // Update password and clear OTP secret
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);
    user.password = hashedPassword;
    user.otpSecret = undefined;
    await user.save();

    res.json({ message: "Password reset successful" });
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
});

module.exports = router;
