const express = require("express");
const bodyParser = require("body-parser");
const mongoose = require("mongoose");
const jwt = require("jsonwebtoken");
const authController = require("./controllers/common/auth_controller");
const feedbackController = require("./controllers/common/feedback_controller");
const studentRoute = require("./routes/student_route");
const rtRoute = require("./routes/rt_route");
const wardenRoute = require("./routes/warden_route");
const app = express();
const bcrypt = require("bcrypt");
const cors = require("cors");
const helmet = require("helmet");
require("dotenv").config();
const checkAuth = require("./middleware/checkAuth");

app.use(helmet());
app.use(cors());
app.use(bodyParser.json());

app.use("/test", (req, res) => {
  res.json({ message: "Hello from server" });
});

mongoose
  .connect(
    "mongodb+srv://NaveenAkash:09naveen@cluster0.3n8lzcq.mongodb.net/outpass?retryWrites=true"
  )
  .then(async () => {
    app.listen(3000, () => {
      console.log("Server running on port 3000");
    });
  })
  .catch((err) => {
    console.log(err);
  });

app.use("/feedback", checkAuth, feedbackController);
app.use("/auth", authController);
app.use("/student", checkAuth, studentRoute);
app.use("/warden", checkAuth, wardenRoute);
app.use("/rt", checkAuth, rtRoute);
