import * as admin from "firebase-admin";
import path from "path";

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
  const fieldName = "Field NKD Main-03"; // Replace With your actual filed name

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
            [ 80.33191365201179,6.167046263564487], // Replace with your actual coordinates
            [ 80.3317643463239,6.166997344021411],
            [ 80.33155421239275,6.166931369946781],
            [ 80.33137172766385,6.1669148764278106],
            [ 80.33116159373401,6.1670193353769065],
            [ 80.33104546708813,6.167134789981375],
            [ 80.33191365201179,6.167046263564487]
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
  };

  // Store in Firestore (adjust path as needed)
  const fieldRef = firestore
    .collection("states")
    .doc("state2") // Replace With your actual estate name
    .collection("sections")
    .doc("NKD Main") // Replace With your actual section name
    .collection("fields")
    .doc("field-03"); // Replace With your actual field id

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
