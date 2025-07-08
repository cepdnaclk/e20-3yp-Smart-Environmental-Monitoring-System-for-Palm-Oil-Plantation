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
              80.59046931661754,
              7.262982880124056
            ],
            [
              80.59041343781263,
              7.262327182992863
            ],
            [
              80.59042991878846,
              7.262305029147896
            ],
            [
              80.5905641210291,
              7.262333055598461
            ],
            [
              80.5907972091278,
              7.262335391135821
            ],
            [
              80.59083255858127,
              7.262879454842221
            ],
            [
              80.59081631399636,
              7.263008368809267
            ],
            [
              80.5907805759079,
              7.263185625453602
            ],
            [
              80.59046931661754,
              7.262982880124056
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
    .doc("field-06");

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
