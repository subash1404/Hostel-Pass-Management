const jwt = require("jsonwebtoken");

const checkAuth = (req, res, next) => {
  const token = req.headers.authorization;
  try {
    const result = jwt.verify(token, process.env.JWT_KEY);
    if (result.role == "student") {
      req.body.USER_uid = result.uid;
      req.body.USER_studentId = result.studentId;
      req.body.USER_email = result.email;
      req.body.USER_username = result.username;
      req.body.USER_role = result.role;
      req.body.USER_phNo = result.phNo;
      req.body.USER_block = result.block;
      req.body.USER_dept = result.dept;
      req.body.USER_fatherName = result.fatherName;
      req.body.USER_motherName = result.motherName;
      req.body.USER_fatherPhNo = result.fatherPhNo;
      req.body.USER_motherPhNo = result.motherPhNo;
      req.body.USER_regNo = result.regNo;
      req.body.USER_year = result.year;
      req.body.USER_section = result.section;
      req.body.USER_roomNo = result.roomNo;
      req.body.USER_photoPath = result.photoPath;
    } else if (result.role == "warden") {
    } else if (result.role == "rt") {
    } else if (result.role == "security") {
    }
    next();
  } catch {
    res.status(401).json({ error: "Not authenticated" });
  }
};

module.exports = checkAuth;
