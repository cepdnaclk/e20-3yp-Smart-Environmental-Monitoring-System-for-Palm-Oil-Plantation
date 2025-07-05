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
  const fieldName = "Field NKD Main-04";

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
              80.33374687953346,
              6.166455227057938
            ],
            [
              80.33371558081984,
              6.1664348809211305
            ],
            [
              80.33366381756127,
              6.1663187882426485
            ],
            [
              80.33364214922045,
              6.166230222676546
            ],
            [
              80.33363251884646,
              6.166135672934956
            ],
            [
              80.33364094542338,
              6.166054288332802
            ],
            [
              80.33367465173109,
              6.165933408241031
            ],
            [
              80.33378540102814,
              6.166111736289011
            ],
            [
              80.33374687953346,
              6.166455227057938
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
    .doc("state2")
    .collection("sections")
    .doc("NKD Main")
    .collection("fields")
    .doc("field-04");

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
