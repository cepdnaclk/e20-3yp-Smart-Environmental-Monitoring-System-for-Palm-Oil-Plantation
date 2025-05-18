import * as admin from "firebase-admin";

// Connect admin SDK to emulator
process.env.FIRESTORE_EMULATOR_HOST = "localhost:8080";

// Use a dummy app name to avoid app conflicts during tests
admin.initializeApp({ projectId: "environment-monitoring-s-d169b" });

const firestore = admin.firestore();

console.log("Is using emulator:", process.env.FIRESTORE_EMULATOR_HOST);


async function runTest() {
  // Step 1: Create a field polygon
// const fieldRef = firestore
//   .collection("states")
//   .doc("state-1")
//   .collection("sections")
//   .doc("section-1")
//   .collection("fields")
//   .doc("field-1");

// await fieldRef.set({
//   boundary: {
//     type: "Polygon",
//     coordinates: [
//       { latitude: 7.246887389928602, longitude: 80.1630941360877 },
//       { latitude: 7.246986484204385, longitude: 80.16318514902224 },
//       { latitude: 7.2470305260983565, longitude: 80.16334497661677 },
//       { latitude: 7.247028324003139, longitude: 80.16344486886231 },
//       { latitude: 7.247023919814879, longitude: 80.16356695938441 },
//       { latitude: 7.246988686299758, longitude: 80.16363799387062 },
//       { latitude: 7.24690500669098, longitude: 80.16372900680511 },
//       { latitude: 7.246816922875254, longitude: 80.16377118352989 },
//       { latitude: 7.246640755192274, longitude: 80.16377784301261 },
//       { latitude: 7.24646018324556, longitude: 80.1637756231865 },
//       { latitude: 7.246224558767921, longitude: 80.163720127494 },
//       { latitude: 7.246123262224998, longitude: 80.16343820937743 },
//       { latitude: 7.2461915272895965, longitude: 80.1632251059209 },
//       { latitude: 7.246299430110312, longitude: 80.16312299384703 },
//       { latitude: 7.246543862936946, longitude: 80.16306083867187 },
//       { latitude: 7.246720030657869, longitude: 80.16304086022365 },
//       { latitude: 7.24683453963938, longitude: 80.16309191625948 },
//       { latitude: 7.2468892641298055, longitude: 80.16309326449795 },
//       { latitude: 7.246887389928602, longitude: 80.1630941360877 } // closing the polygon
//     ]
//   },
//   soilMoisture: null, // you can replace null with actual data
//   npk: {
//     nitrogen: null,     // replace with actual values if available
//     phosphorus: null,
//     potassium: null
//   }
// });


  // Step 2: Create a raw reading within that polygon to trigger the function
  // const readingRef = firestore.collection("raw_readings").doc("reading-1");
  // await readingRef.set({
  //   geoPoint: new admin.firestore.GeoPoint(7.245343424301296, 80.16473623170651,), // inside polygon
  //   soilMoisture: 25,
  //   nitrogen: 12,
  //   phosphorus: 8,
  //   potassium: 4,
  // });

  const readingRef = firestore.collection("raw_readings").doc("reading-7");

  await readingRef.set({
    geoPoint: new admin.firestore.GeoPoint(7.243772239637778, 80.16845008390823),
    soilMoisture: 21,
    nitrogen: 16,
    phosphorus: 5,
    potassium: 6,
    timestamp: admin.firestore.Timestamp.fromDate(new Date("2025-03-03T09:41:34Z")) // 15:11:34 UTC+5:30
  });

    console.log("Test raw reading created.");
  }

runTest().then(() => {
  console.log("Done.");
  process.exit();
});
