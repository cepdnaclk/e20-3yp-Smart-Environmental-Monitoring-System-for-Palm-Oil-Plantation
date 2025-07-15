import * as admin from "firebase-admin";
import path from "path";
// import path from "path";

// // Connect admin SDK to emulator
// process.env.FIRESTORE_EMULATOR_HOST = "localhost:8080";

// // Use a dummy app name to avoid app conflicts during tests
// admin.initializeApp({ projectId: "environment-monitoring-s-d169b" });
const serviceAccount = require(path.join("C://Users//ASUS//Desktop//Com_Sem_6//e20-3yp-Smart-Environmental-Monitoring-System-for-Palm-Oil-Plantation//Software//flutter_application_1//functions//environment-monitoring-s-d169b-firebase-adminsdk-fbsvc-a732b6dc9d.json"));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: "environment-monitoring-s-d169b"
});

const firestore = admin.firestore();

console.log("Is using emulator:", process.env.FIRESTORE_EMULATOR_HOST);


async function runTest() {

  const readingRef = firestore.collection("raw_readings").doc("reading-47");

  await readingRef.set({
    geoPoint: new admin.firestore.GeoPoint(7.254651234303168, 80.59128310219143),
    soilMoisture: 4,
    nitrogen: 75,
    phosphorus: 8,
    potassium: 4,
    // timestamp: admin.firestore.Timestamp.fromDate(new Date("2025-06-24T09:41:34Z")) // 15:11:34 UTC+5:30
    timestamp: admin.firestore.Timestamp.now()
  });

    console.log("Test raw reading created.");
  }

runTest().then(() => {
  console.log("Done.");
  process.exit();
});
