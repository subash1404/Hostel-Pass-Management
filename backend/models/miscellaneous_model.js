const mongoose = require("mongoose");
const schema = mongoose.Schema;

const MiscellaneousSchema = new schema(
  {
    version: {
      type: String,
      required: true,
    },
    maintenance: {
      type: String,
      required: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("miscellaneous", MiscellaneousSchema);
