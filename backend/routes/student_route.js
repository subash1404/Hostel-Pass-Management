const express = require("express");
const router = express.Router();
const passController = require("../controllers/student/pass_controller");
const blockController = require("../controllers/student/block_controller");

router.use("/block", blockController);
router.use("/pass", passController);

module.exports = router;
