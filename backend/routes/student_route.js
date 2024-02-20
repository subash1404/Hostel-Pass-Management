const express = require("express");
const router = express.Router();
const passController = require("../controllers/student/pass_controller");

router.use("/pass", passController);

module.exports = router;
