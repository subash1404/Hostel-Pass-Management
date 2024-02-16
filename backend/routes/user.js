const express = require('express');
const bcrypt = require('bcrypt');
const router = express.Router();
const jwt = require('jsonwebtoken');
const User =  require('../models/user');

router.post('/login',async (req,res) => {
    // const { email , password } = req.body;
    // const email = req.body.email;
    // const password = req.body.password;
    email=  "test@gmail.com";
    password = "aaaaaa";
    const user = await User.findOne({email}); 
    if(!user){
        return res.status(401).json({message:"User not found"});
    }

    const isValidPassword = await bcrypt.compare(password,user.password);
    if(!isValidPassword){
        return res.status(401).json({ message: "Invalid Credentials" }); 
    }
    
    const jwtToken = jwt.sign({id:user._id,email:user.email},"SecretKey");
    res.json({
        jwtToken,
        email:user.email,
        // phno:user.phno,
        // father:user.father,
        // mother:user.mother,
        // fatherphno:user.fatherphno,
        // motherphno:user.motherphno,
        // admno:user.admno,
        // branch:user.branch,
        // year:user.year,
        // sec:user.sec,
        // block:user.block,
        // roomno:user.roomno,
    })
});

module.exports = router;