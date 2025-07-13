import * as admin from "firebase-admin";
// import path from "path";

process.env.FIRESTORE_EMULATOR_HOST = "localhost:8080";
// Load your service account key
// const serviceAccount = require(path.join(
//   "C://Users//ASUS//Desktop//Com_Sem_6//e20-3yp-Smart-Environmental-Monitoring-System-for-Palm-Oil-Plantation//Software//flutter_application_1//functions//environment-monitoring-s-d169b-firebase-adminsdk-fbsvc-a732b6dc9d.json"
// ));

// Initialize Firebase Admin
admin.initializeApp({
  // credential: admin.credential.cert(serviceAccount),
  projectId: "environment-monitoring-s-d169b",
});

const firestore = admin.firestore();

async function storeFieldData() {
  const fieldName = "Field NKD Main-06";

  // Example GeoJSON object (could be loaded from file or request)
  const geoJson = {
    type: "FeatureCollection",
    features: [
      {
        type: "Feature",
        properties: {},
        geometry: {
          coordinates: [
                                 [
            [
              80.31465633486613,
              6.163054861509508
            ],
            [
              80.31421110884133,
              6.163257648786015
            ],
            [
              80.31398421692933,
              6.163432631746261
            ],
            [
              80.31372783101017,
              6.163222310511102
            ],
            [
              80.31390586517858,
              6.163099863164547
            ],
            [
              80.31410519078207,
              6.163034508048355
            ],
            [
              80.31425998619903,
              6.162827901501004
            ],
            [
              80.31440205870416,
              6.162505342137337
            ],
            [
              80.31467984226305,
              6.162501125674439
            ],
            [
              80.31512152620525,
              6.162504521021958
            ],
            [
              80.31510103571253,
              6.162679947293839
            ],
            [
              80.3150179353841,
              6.162838396779165
            ],
            [
              80.31494735702125,
              6.1628689548894755
            ],
            [
              80.31478457144317,
              6.16295836564467
            ],
            [
              80.31465633486613,
              6.163054861509508
            ]
          ],
          ],
          type: "Polygon",
        },
      },
    ],
  };

  // Convert coordinates to GeoPoints (GeoJSON uses [lng, lat])
  const polygonCoordinates = geoJson.features[0].geometry.coordinates[0].map(
    ([lng, lat]) => new admin.firestore.GeoPoint(lat, lng));

  const fieldData = {
    fieldName,
    boundary: {
      type: "Polygon",
      coordinates: polygonCoordinates,
    },
    // soilMoisture: null,
    // npk: {
    //   nitrogen: null,
    //   phosphorus: null,
    //   potassium: null,
    // },
  };

  // Store in Firestore (adjust path as needed)
  const fieldRef = firestore
    .collection("states")
    .doc("n5uRHNmnCdJtRKor32S0")
    .collection("sections")
    .doc("s2FdM8xYNrcDij5UEWlR")
    .collection("fields")
    .doc("field-07");

  await fieldRef.set(fieldData);

  console.log("Field data saved successfully.");
}

storeFieldData()
  .then(() => {
    console.log("Done.");
    process.exit();
  })
  .catch((err) => {
    console.error("Error:", err);
    process.exit(1);
  });
