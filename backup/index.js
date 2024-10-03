const mongoose = require("mongoose");
const express = require("express");
const app = express();
const cors = require("cors");
const path = require("path");
const fs = require("fs");
const helmet = require("helmet");
const bodyParser = require("body-parser");
require("dotenv").config();
const cron = require("node-cron");

app.use(helmet());
app.use(cors());
app.use(bodyParser.json());

process.env.TZ = "Asia/Kolkata";


mongoose
  .connect(process.env.MONGO_URI)
  .then(async () => {
    app.listen(3000, () => {
      console.log("Server running on port 3000");
    });
  })
  .catch((err) => {
    console.log(err);
  });

// Define the backup file path

// Schedule the backup to run every 20 seconds
cron.schedule('0 0 * * *', () => {
  backupDatabase();
});

const backupDatabase = async () => {
  try {
    const backupFilePath = path.join(
      __dirname,
      "backups",
      `${new Date()
        .toISOString()
        .split(".")[0]
        .replaceAll(":", "-")
        .replace("T", "__")}.json`
    );
    const db = mongoose.connection.db;
    const collections = await db.listCollections().toArray();

    // Prepare backup data
    let backupData = {};

    for (let collectionInfo of collections) {
      const collectionName = collectionInfo.name;
      const collection = db.collection(collectionName);
      const data = await collection.find({}).toArray();
      backupData[collectionName] = data;
    }

    // Append data to the backup file
    fs.appendFileSync(backupFilePath, JSON.stringify(backupData, null, 2));

    console.log("Backup completed successfully");
  } catch (err) {
    console.error("Error during backup", err);
  }
};

// Set up a route to serve the backup file
app.get("/backup", async (req, res) => {
  await backupDatabase()
  res.send("Backup completed successfully");

  // if (fs.existsSync(backupFilePath)) {
  //   res.sendFile(backupFilePath);
  // } else {
  //   res.status(404).send("Backup file not found");
  // }
});
