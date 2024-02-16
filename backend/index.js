const express = require('express')
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');
const user = require('./routes/user_route');
const app = express();
const bcrypt = require('bcrypt');
const cors = require("cors");
const helmet = require("helmet");

app.use(helmet());
app.use(cors());

mongoose.connect(
  "mongodb+srv://NaveenAkash:09naveen@cluster0.3n8lzcq.mongodb.net/outpass?retryWrites=true").then(async () => {
    app.listen(3000,() => {console.log("Connected")});
  }).catch((err) => {
    console.log(err);
  });

  app.use('/user',user);