const express = require("express");
const router = express.Router();
const blockController = require("../controllers/rt/block_controller");


// router.use("/rt", rtController);

router.use("/block", blockController);


module.exports = router;
