const express = require("express");
const router = express.Router();
const blockController = require("../controllers/common/block_controller");

router.use("/block", blockController);


module.exports =  router;
