import * as admin from "firebase-admin";


// Path to your downloaded service account key
const serviceAccount = require("C:/Users/ASUS/Desktop/Com_Sem_6/e20-3yp-Smart-Environmental-Monitoring-System-for-Palm-Oil-Plantation/Software/flutter_application_1/functions/environment-monitoring-s-d169b-firebase-adminsdk-fbsvc-c3680364ed.json"); // make sure it's in the same folder or provide the full path

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
const firestore = admin.firestore();

// // 👇 This tells firebase-admin to connect to the emulator instead of the cloud
// process.env.FIRESTORE_EMULATOR_HOST = "localhost:8080";

async function runTest() {
  const testStateRef = firestore.collection("states").doc("test-state");
  const sectionRef = testStateRef.collection("sections").doc("test-section");
  const fieldRef = sectionRef.collection("fields").doc("test-field");

  // Add polygon field (approx square area)
  await fieldRef.set({
    coordinates: [
      { latitude: 7.247, longitude: 80.163 },
      { latitude: 7.247, longitude: 80.164 },
      { latitude: 7.248, longitude: 80.164 },
      { latitude: 7.248, longitude: 80.163 },
    ],
    type: "polygon",
  });

  // Trigger function by creating raw reading
  const readingRef = firestore.collection("raw_readings").doc("reading-1");
  await readingRef.set({
    geoPoint: new admin.firestore.GeoPoint(7.2475, 80.1635),
    soilMoisture: 30,
    nitrogen: 15,
    phosphorus: 10,
    potassium: 5,
  });

  console.log("Test raw reading created.");
}

runTest().then(() => {
  console.log("Done.");
  process.exit();
});
