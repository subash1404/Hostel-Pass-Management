const mongoose =  require('mongoose');
const schema = mongoose.Schema;

const UserScheme = new schema(
    {
        username:{
            type:String,
            required:true,
        },
        email:{
            type:String,
            required:true,
        },
        password:{
            type:String,
            required:true
        },
        phno:{
            type:String,
            required:true,
        },
        father:{
            type:String,
            required:true,
        },
        mother:{
            type:String,
            required:true,
        },
        fatherphno:{
            type:String,
            required:true,
        },
        motherphno:{
            type:String,
            required:true,
        },
        admno:{
            type:String,
            required:true,
        },
        branch:{
            type:String,
            required:true,
        },
        year:{
            type:String,
            required:true,
        },
        sec:{
            type:String,
            required:true,
        },
        block:{
            type:Number,
            required:true,
        },
        roomno:{
            type:Number,
            required:true,
        },
    },
    {timestamps:true},
);

module.exports = mongoose.model("users",UserScheme);