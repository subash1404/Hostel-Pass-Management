const { MongoClient } = require("mongodb");
const { Readable } = require("stream");
const createCsvWriter = require("csv-writer").createObjectCsvStringifier;
const express = require("express");
const moment = require("moment");
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

async function exportData(res, blockNoFilter, genderFilter) {
  const client = new MongoClient(url, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    serverSelectionTimeoutMS: 5000,
  });

  try {
    await client.connect();
    console.log("Connected to database!");

    const db = client.db(dbName);
    const passCollection = db.collection(passCollectionName);
    const studentCollection = db.collection(studentCollectionName);

    let studentQuery = { gender: genderFilter };
    if (blockNoFilter) {
      studentQuery.blockNo = blockNoFilter;
    }

    // Fetch all passes
    const passes = await passCollection.find().toArray();

    // Collect all studentIds from the passes
    const studentIds = passes.map(pass => pass.studentId);

    // Query all students in bulk using $in operator
    const students = await studentCollection
      .find({ studentId: { $in: studentIds }, ...studentQuery })
      .toArray();

    // Create a map of studentId to student data for fast lookup
    const studentMap = students.reduce((map, student) => {
      map[student.studentId] = student;
      return map;
    }, {});

    // Prepare the combined data
    const records = passes
      .map(pass => {
        const student = studentMap[pass.studentId];
        if (student) {
          return {
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
        }
        return null;
      })
      .filter(record => record !== null); // Filter out any null records (passes without matching students)

    // Create a CSV stringifier
    const csvStringifier = createCsvWriter({
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

    // Write CSV data to a string
    const csvData = csvStringifier.getHeaderString() + csvStringifier.stringifyRecords(records);

    // Create a readable stream from the CSV data
    const csvStream = new Readable();
    csvStream.push(csvData);
    csvStream.push(null); // Signal end of stream

    // Set the response headers for a file download
    res.setHeader("Content-disposition", "attachment; filename=passes_students_data.csv");
    res.setHeader("Content-Type", "text/csv");

    // Pipe the CSV stream directly to the response
    csvStream.pipe(res);

  } catch (err) {
    console.error("An error occurred:", err);
    res.status(500).send("An error occurred while exporting data.");
  } finally {
    await client.close();
  }
}

// Boys' Hostel API
app.get("/fetch/boys", async (req, res) => {
  const blockNo = req.query.blockNo ? parseInt(req.query.blockNo, 10) : null;
  await exportData(res, blockNo, "M");
});

// Girls' Hostel API
app.get("/fetch/girls", async (req, res) => {
  const blockNo = req.query.blockNo ? parseInt(req.query.blockNo, 10) : null;
  await exportData(res, blockNo, "F");
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
