import * as admin from "firebase-admin";
import path from "path";


// Load your service account key
const serviceAccount = require(path.join(
  "C://Users//ASUS//Desktop//Com_Sem_6//e20-3yp-Smart-Environmental-Monitoring-System-for-Palm-Oil-Plantation//Software//flutter_application_1//functions//environment-monitoring-s-d169b-firebase-adminsdk-fbsvc-a732b6dc9d.json"
));

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: "environment-monitoring-s-d169b",
});

const firestore = admin.firestore();

async function storeFieldData() {
  const fieldName = "Field NKD Main-01";

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
              80.33397464196185,
              6.165986907241248
            ],
            [
              80.3340928693761,
              6.16623096787896
            ],
            [
              80.3340663969862,
              6.166522814896467
            ],
            [
              80.33392016923756,
              6.166505822234555
            ],
            [
              80.33397464196185,
              6.165986907241248
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
    .doc("state")
    .collection("sections")
    .doc("NKD Main")
    .collection("fields")
    .doc("field-01");

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
