const { MongoClient } = require("mongodb");
const createCsvWriter = require("csv-writer").createObjectCsvWriter;
const express = require("express");
const fs = require("fs");
const path = require("path");
const moment = require("moment");
const { type } = require("os");
require("dotenv").config();


const app = express();
const port = 3000;

const url = process.env.MONGO_URI;
const dbName = "outpass";
const passCollectionName = "passes";
const studentCollectionName = "students";

function formatDate(date) {
  return moment(date).format("DD-MM-YYYY hh:mm A");
}

const csvWriter = createCsvWriter({
  path: "passes_students_data.csv",
  header: [
    { id: "studentId", title: "Student ID" },
    { id: "type", title: "Type" },
    { id: "reason", title: "Reason" },
    { id: "status", title: "Status" },
    { id: "destination", title: "Destination" },
    { id: "isActive", title: "Is Active" },
    { id: "approvedBy", title: "Approved By" },
    { id: "confirmedWith", title: "Confirmed With" },
    { id: "expectedOut", title: "Expected Out" },
    { id: "expectedIn", title: "Expected In" },
    { id: "isSpecialPass", title: "Is Special Pass" },
    { id: "exitScanAt", title: "Exit Scan At" },
    { id: "exitScanBy", title: "Exit Scan By" },
    { id: "entryScanAt", title: "Entry Scan At" },
    { id: "entryScanBy", title: "Entry Scan By" },
    // Student fields
    { id: "username", title: "Student Name" },
    { id: "gender", title: "Gender" },
    { id: "regNo", title: "Registration Number" },
    { id: "phNo", title: "Phone Number" },
    { id: "fatherName", title: "Father Name" },
    { id: "motherName", title: "Mother Name" },
    { id: "fatherPhNo", title: "Father Phone Number" },
    { id: "motherPhNo", title: "Mother Phone Number" },
    { id: "dept", title: "Department" },
    { id: "year", title: "Year" },
    { id: "section", title: "Section" },
    { id: "blockNo", title: "Block Number" },
    { id: "roomNo", title: "Room Number" },
  ],
});

async function exportData(blockNoFilter, genderFilter) {
  const client = new MongoClient(url, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    serverSelectionTimeoutMS: 5000,
  });

  try {
    await client.connect();
    console.log("Connected to database!");

    const filePath = "passes_students_data.csv";

    if (fs.existsSync(filePath)) {
      fs.unlinkSync(filePath);
    }

    const db = client.db(dbName);
    const passCollection = db.collection(passCollectionName);
    const studentCollection = db.collection(studentCollectionName);

    let studentQuery = { gender: genderFilter };
    if (blockNoFilter) {
      studentQuery.blockNo = blockNoFilter;
    }
    console.log(studentQuery);

    const passes = await passCollection.find().toArray();
    let records = [];

    console.log(passes.length);
    for (const pass of passes) {
      const student = await studentCollection.findOne({
        studentId: pass.studentId,
        ...studentQuery,
      });

      if (student) {
        const combinedData = {
          studentId: pass.studentId,
          type: pass.type,
          reason: pass.reason,
          status: pass.status,
          destination: pass.destination,
          isActive: pass.isActive,
          approvedBy: pass.approvedBy,
          confirmedWith: pass.confirmedWith,
          expectedOut: formatDate(pass.expectedOut),
          expectedIn: formatDate(pass.expectedIn),
          isSpecialPass: pass.isSpecialPass,
          exitScanAt: formatDate(pass.exitScanAt),
          exitScanBy: pass.exitScanBy,
          entryScanAt: formatDate(pass.entryScanAt),
          entryScanBy: pass.entryScanBy,
          username: student.username,
          gender: student.gender,
          regNo: student.regNo,
          phNo: student.phNo,
          fatherName: student.fatherName,
          motherName: student.motherName,
          fatherPhNo: student.fatherPhNo,
          motherPhNo: student.motherPhNo,
          dept: student.dept,
          year: student.year,
          section: student.section,
          blockNo: student.blockNo,
          roomNo: student.roomNo,
        };
        records.push(combinedData);
      }
    }

    if (records.length > 0) {
      await csvWriter.writeRecords(records);
      console.log("Data exported to CSV successfully!");
    } else {
      console.log("No records found to export.");
    }
  } catch (err) {
    console.error("An error occurred:", err);
  } finally {
    await client.close();
  }
}

// Boys' Hostel API
app.get("/fetch/boys", async (req, res) => {
  const blockNo = req.query.blockNo ? parseInt(req.query.blockNo, 10) : null;
  await exportData(blockNo, "M");
  const filePath = path.join(__dirname, "passes_students_data.csv");
  res.download(filePath, "boys_passes_students_data.csv", (err) => {
    if (err) {
      console.error("Error sending file:", err);
      res.status(500).send("Error sending file.");
    }
  });
});

// Girls' Hostel API
app.get("/fetch/girls", async (req, res) => {
  const blockNo = req.query.blockNo ? parseInt(req.query.blockNo, 10) : null;
  await exportData(blockNo, "F");
  const filePath = path.join(__dirname, "passes_students_data.csv");
  res.download(filePath, "girls_passes_students_data.csv", (err) => {
    if (err) {
      console.error("Error sending file:", err);
      res.status(500).send("Error sending file.");
    }
  });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
