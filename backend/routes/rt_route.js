const express = require("express");
const router = express.Router();
const blockController = require("../controllers/rt/block_controller");
const passController = require("../controllers/rt/pass_controller");

router.use("/block", blockController);

router.use("/pass", passController);


module.exports =  router;
