const express = require("express");
const bodyParser = require("body-parser");
const mongoose = require("mongoose");
const jwt = require("jsonwebtoken");
const authController = require("./controllers/common/auth_controller");
const bugReportController = require("./controllers/common/bug_report_controller");
const profilePicController = require("./controllers/common/profile_pic_controller");
const studentRoute = require("./routes/student_route");
const securityRoute = require("./routes/security_route");
const rtRoute = require("./routes/rt_route");
const wardenRoute = require("./routes/warden_route");
const app = express();
const bcrypt = require("bcrypt");
const cors = require("cors");
const helmet = require("helmet");
require("dotenv").config();
const checkAuth = require("./middleware/checkAuth");
const Miscellaneous = require("./models/miscellaneous_model");
const path = require("path");
const fs = require("fs");
const Pass = require("./models/pass_model");
const cron = require("node-cron");
const Student = require("./models/student_model")
const User = require("./models/user_model")
const nodemailer = require("nodemailer");



process.env.TZ = "Asia/Kolkata";

app.use(helmet());
app.use(cors());
app.use(bodyParser.json());

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL,
    pass: process.env.PASSWD,
  },
});

app.use("/test", (req, res) => {
  res.json({ message: "Hello from server" });
});

app.use("/timeTest", (req, res) => {
  const currentTime = Date.now();
  const initialTime = new Date("2024-03-19T13:57:00.000");
  const limitTime = new Date(initialTime.getTime() + 12 * 60000); // 60000 milliseconds in a minute

  if (currentTime > limitTime) {
    console.log("The time has exceeded the limit.");
  } else {
    console.log("The time has not exceeded the limit.");
  }

  res.send();
});
mongoose
  .connect(process.env.MONGO_URI)
  .then(async () => {
    app.listen(3000, () => {
      console.log("Server running on port 3000");
    });
  })
  .catch((err) => {
    console.log(err);
  });

app.get("/miscellaneous", async (req, res) => {
  try {
    const miscellaneous = await Miscellaneous.findOne({});
    res.json(miscellaneous);
  } catch (e) {
    res.json({ message: "Internal Server Error" });
  }
});

app.get("/getBranch", (req, res) => {
  res.json({ branch: "main" });
});

app.get("/getTime", (req, res) => {
  res.json({
    dateNow: Date.now(),
    day: new Date(Date.now()).getDay(),
    date: new Date(Date.now()).getDate(),
    month: new Date(Date.now()).getMonth(),
    hour: new Date(Date.now()).getHours(),
    minute: new Date(Date.now()).getMinutes(),
    seconds: new Date(Date.now()).getSeconds(),
    UTCdate: new Date(Date.now()).getUTCDate(),
    UTCmonth: new Date(Date.now()).getUTCMonth(),
    UTChour: new Date(Date.now()).getUTCHours(),
    UTCminute: new Date(Date.now()).getUTCMinutes(),
    UTCseconds: new Date(Date.now()).getUTCSeconds(),
  });
});

app.use("/bugReport", checkAuth, bugReportController);
app.use("/auth", authController);
app.use("/profile", checkAuth, profilePicController);
app.use("/student", checkAuth, studentRoute);
app.use("/warden", checkAuth, wardenRoute);
app.use("/rt", checkAuth, rtRoute);
app.use("/security", checkAuth, securityRoute);

function getEndOfDay(date) {
  const endOfDay = new Date(date);
  endOfDay.setHours(23, 59, 59, 999);
  return endOfDay;
}

cron.schedule('1 0 * * *', async () => {
  try {
    const passes = await Pass.find({
      isActive: true,
      status: { $in: ["Approved", "Pending"] },
    });


    for (let pass of passes) {
      // if (pass.status === "Approved" || pass.status === "Pending") {
      const expectedOutTime = new Date(pass.expectedOut).getTime();
      const qrEndTime = getEndOfDay(expectedOutTime).getTime();
      
      if (Date.now() > qrEndTime) {
        pass.isActive = false;
        pass.status = "Expired";
        console.log(pass);
        await Pass.findOneAndUpdate(
          { passId: pass.passId },
          { isActive: false, status: "Expired" }
        );
        const user = await User.findOne({ uid: pass.uid });
        const expiredMailOptions = {
          from: process.env.EMAIL,
          to: user.email,
          subject: "Pass Expired Notification",
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
                <p>Your pass has <strong style="color: #ff4d4f;">EXPIRED</strong>.</p>
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
                <p>Unfortunately, your pass has expired. If you need a new pass, please submit a new request.</p>
              </div>
              <div class="footer">
                <p>If you have any questions, feel free to reach at <a href="mailto:svcehostel@svce.ac.in">svcehostel@svce.ac.in</a></p>
              </div>
            </div>
          </body>
        </html>`,
        };
        await transporter.sendMail(expiredMailOptions)
      }
      // }
    }
  } catch (error) {
    console.error("Error updating expired passes:", error);
  }
});
