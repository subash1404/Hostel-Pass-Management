const express = require("express");
const router = express.Router();
const passController = require("../controllers/warden/pass_controller");
const blockController = require("../controllers/warden/block_controller");

router.use("/pass", passController);
router.use(blockController);

module.exports = router;