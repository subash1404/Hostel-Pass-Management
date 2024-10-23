const express = require("express");
const bcrypt = require("bcrypt");
const router = express.Router();
const jwt = require("jsonwebtoken");
const User = require("../../models/user_model");
const Pass = require("../../models/pass_model");
const QR = require("../../models/qr_model");
const Student = require("../../models/student_model");
const Rt = require("../../models/rt_model");
const { v4: uuidv4 } = require("uuid");
const { aesEncrypt, aesDecrypt } = require("../../utils/aes");
const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL,
    pass: process.env.PASSWD,
  },
});

router.get("/getPass", async (req, res) => {
  try {
    const rt = await Rt.findOne({
      uid: req.body.USER_uid,
    });

    if (!rt) {
      return res.status(404).json({ message: "Rt not found" });
    }
    const tempBlocks = rt.temporaryBlock;
    const blockStudents = await Student.find({
      blockNo: { $in: [...tempBlocks, req.body.USER_permanentBlock] },
    });
    var passes = [];
    for (let student of blockStudents) {
      var tempPass = [];
      var studentPasses = await Pass.find({
        studentId: student.studentId,
        // isSpecialPass: false,
      });
      for (const pass of studentPasses) {
        tempPass.push({
          ...pass._doc,
          studentName: student.username,
          gender: student.gender,
          dept: student.dept,
          fatherPhNo: student.fatherPhNo,
          motherPhNo: student.motherPhNo,
          phNo: student.phNo,
          roomNo: student.roomNo,
          blockNo: student.blockNo,
          year: student.year,
          isLate:
            pass.type === "GatePass"
              ? new Date(pass.entryScanAt).getTime() >
              new Date(pass.expectedIn).getTime() + 60 * 60000
              : new Date().getTime() >
              getEndOfDay(pass.expectedIn).getTime(),
          isExceeding:
            pass.type === "GatePass"
              ? new Date().getTime() >
              new Date(pass.expectedIn).getTime() + 3 * 60 * 60000
              : new Date().getTime() >
              getEndOfDay(pass.expectedIn).getTime(),
        });
      }

      passes.push(...tempPass);
    }
    console.log(passes);

    function getEndOfDay(date) {
      const endOfDay = new Date(date);
      endOfDay.setHours(23, 59, 59, 999);
      return endOfDay;
    }

    passes.filter(async (pass) => {
      if (pass.isActive) {
        pass.qrId = aesEncrypt(pass.qrId, process.env.AES_KEY);
        // if (pass.status === "Approved" || pass.status === "Pending") {
        //   const expectedOutTime = new Date(pass.expectedOut).getTime();
        //   const qrEndTime = getEndOfDay(expectedOutTime).getTime();
        //   // console.log(Date.now());
        //   // console.log(qrEndTime);
        //   // const timestamp = 1715192999999;
        //   // const date = new Date(timestamp);
        //   // console.log(date.toString());
        //   if (Date.now() > qrEndTime) {
        //     pass.isActive = false;
        //     pass.status = "Expired";
        //     // pass.save();
        //     console.log("rt");
        //     await Pass.findOneAndUpdate(
        //       { passId: pass.passId },
        //       { isActive: false, status: "Expired" }
        //     );
        //     return false;
        //   }
        // }
      }
      return true;
    });

    passes.sort((a, b) => {
      return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
    });

    res.json({ data: passes });
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
});
// router.get("/getPass", async (req, res) => {
//   try {
//     const blockStudents = await Student.find({
//       blockNo: req.body.USER_permanentBlock,
//     });

//     var passes = [];
//     for (let student of blockStudents) {
//       var tempPass = [];
//       var studentPasses = await Pass.find({
//         studentId: student.studentId,
//         // isSpecialPass: false,
//       });
//       for (const pass of studentPasses) {
//         tempPass.push({
//           ...pass._doc,
//           studentName: student.username,
//           dept: student.dept,
//           fatherPhNo: student.fatherPhNo,
//           motherPhNo: student.motherPhNo,
//           phNo: student.phNo,
//           roomNo: student.roomNo,
//           blockNo:student.blockNo,
//           year: student.year,
//         });
//       }
//       passes.push(...tempPass);
//     }
//     res.json({ data: passes });
//   } catch (error) {
//     res.status(500).json({ message: "Internal Server Error" });
//   }
// });

router.post("/approvePass", async (req, res) => {
  try {
    const { passId, rtName, confirmedWith } = req.body;
    const pass = await Pass.findOneAndUpdate(
      { passId: passId },
      { status: "Approved", approvedBy: rtName, confirmedWith: confirmedWith },
      { new: true }
    );
    if (!pass) {
      return res.status(404).json({ message: "Pass not found" });
    }
    const user = await User.findOne({ uid: pass.uid });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    const approvalMailOptions = {
      from: process.env.EMAIL,
      to: user.email,
      subject: "Pass Request Approved",
      html: `
      <html>
      <head>
        <style>
      body {
        font-family: 'Arial', sans-serif;
        background-color: #fffbff;
        margin: 0;
        padding: 0;
      }

      .container {
        max-width: 600px;
        margin: 0 auto;
        background-color: #fffbff;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      }

      .header {
        background-color: #a0f57d;
        color: #000;
        text-align: center;
        padding: 20px;
      }

      .content {
        padding: 30px;
        text-align: center;
      }

      .content h2 {
        color: #4CAF50;
      }

      .pass-details {
        font-size: 18px;
        color: #333333;
        margin-top: 20px;
      }

      .footer {
        background-color: #eeeeee;
        padding: 10px;
        text-align: center;
        font-size: 12px;
      }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>SVCE Hostel Management System</h1>
          </div>
          <div class="content">
            <h2>Hi ${user.username},</h2>
            <p>Your pass request has been <strong style="color: #4CAF50;">APPROVED</strong> by ${rtName}.</p>
            <div class="pass-details">
              <p><strong>Pass Type:</strong> ${pass.type}</p>
              <p><strong>Destination:</strong> ${pass.destination}</p>
              <p><strong>Leaving Time:</strong> ${new Date(pass.expectedOut).toLocaleString('en-US', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: 'numeric',
        minute: 'numeric',
        hour12: true
      })}</p>
              <p><strong>Returning Time:</strong> ${new Date(pass.expectedIn).toLocaleString('en-US', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: 'numeric',
        minute: 'numeric',
        hour12: true
      })}</p>
            </div>
            <p>Please present the QR code generated in the app at the main gate before your departure.</p>
          </div>
          <div class="footer">
            <p>If you have any questions, feel free to reach out at <a href="mailto:svcehostel@svce.ac.in">svcehostel@svce.ac.in</a></p>
          </div>
        </div>
      </body>
    </html>`,
    };
    await transporter.sendMail(approvalMailOptions);
    res.json(pass);
  } catch (error) {
    console.error("Error approving pass:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
});

router.post("/rejectPass", async (req, res) => {
  try {
    const { passId, rtName } = req.body;
    const pass = await Pass.findOneAndUpdate(
      { passId: passId },
      {
        status: "Rejected",
        isActive: false,
        approvedBy: rtName,
        confirmedWith: "None",
      },
      { new: true }
    );
    if (!pass) {
      return res.status(404).json({ message: "Pass not found" });
    }
    const user = await User.findOne({ uid: pass.uid });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    const rejectionMailOptions = {
      from: process.env.EMAIL,
      to: user.email,
      subject: "Pass Request Rejected",
      html: `
      <html>
      <head>
        <style>
          body {
            font-family: 'Arial', sans-serif;
            background-color: #fffbff;
            margin: 0;
            padding: 0;
          }
    
          .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #fffbff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
          }
    
          .header {
            background-color: #f57d7d;
            color: #ffffff;
            text-align: center;
            padding: 20px;
          }
    
          .content {
            padding: 30px;
            text-align: center;
          }
    
          .content h2 {
            color: #e43f3f;
          }
    
          .pass-details {
            font-size: 18px;
            color: #333333;
            margin-top: 20px;
          }
    
          .footer {
            background-color: #eeeeee;
            padding: 10px;
            text-align: center;
            font-size: 12px;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>SVCE Hostel Management System</h1>
          </div>
          <div class="content">
            <h2>Hi ${user.username},</h2>
            <p>We regret to inform you that your pass request has been <strong style="color: #e43f3f;">REJECTED</strong> by ${rtName}.</p>
            <div class="pass-details">
              <p><strong>Pass Type:</strong> ${pass.type}</p>
              <p><strong>Destination:</strong> ${pass.destination}</p>
                            <p><strong>Leaving Time:</strong> ${new Date(pass.expectedOut).toLocaleString('en-US', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: 'numeric',
        minute: 'numeric',
        hour12: true
      })}</p>
              <p><strong>Returning Time:</strong> ${new Date(pass.expectedIn).toLocaleString('en-US', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: 'numeric',
        minute: 'numeric',
        hour12: true
      })}</p>
            </div>
            <p>Please contact ${rtName} for further details.</p>
          </div>
          <div class="footer">
            <p>If you have any questions, feel free to reach at <a href="mailto:svcehostel@svce.ac.in">svcehostel@svce.ac.in</a></p>
          </div>
        </div>
      </body>
    </html>`,
    };
    await transporter.sendMail(rejectionMailOptions);
    res.json(pass);
  } catch (error) {
    console.error("Error rejecting pass:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
});

module.exports = router;
