const express = require("express");
const bodyParser = require("body-parser");
const mongoose = require("mongoose");
const jwt = require("jsonwebtoken");
const userRoute = require("./routes/user_route");
const passRoute = require("./routes/pass_route");
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

app.use("/user", userRoute);
app.use("/pass", checkAuth, passRoute);
