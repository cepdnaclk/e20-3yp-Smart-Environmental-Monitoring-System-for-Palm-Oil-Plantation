import * as admin from "firebase-admin";
import path from "path";
// import path from "path";

// process.env.FIRESTORE_EMULATOR_HOST = "localhost:8080";
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
  const fieldName = "Field NKD Main-03";

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
              80.33191365201179,
              6.167046263564487
            ],
            [
              80.3317643463239,
              6.166997344021411
            ],
            [
              80.33155421239275,
              6.166931369946781
            ],
            [
              80.33137172766385,
              6.1669148764278106
            ],
            [
              80.33116159373401,
              6.1670193353769065
            ],
            [
              80.33104546708813,
              6.167134789981375
            ],
            [
              80.33092381060311,
              6.167222755376486
            ],
            [
              80.33080215411678,
              6.167321716429015
            ],
            [
              80.33072473635286,
              6.16737119694902
            ],
            [
              80.33067496779125,
              6.167470157973867
            ],
            [
              80.33056990082633,
              6.1674206774644205
            ],
            [
              80.33039847577714,
              6.167338209936659
            ],
            [
              80.33020493136866,
              6.167261240232648
            ],
            [
              80.3301883418473,
              6.167162279168835
            ],
            [
              80.33023258056966,
              6.167024833216004
            ],
            [
              80.33026575961122,
              6.1669203742679315
            ],
            [
              80.33025469993021,
              6.166793923934051
            ],
            [
              80.3302104612091,
              6.166606997299013
            ],
            [
              80.33019940152815,
              6.166469551202269
            ],
            [
              80.3301772821676,
              6.16627162876064
            ],
            [
              80.33016622248664,
              6.166106693334868
            ],
            [
              80.33007774504182,
              6.16590271190077
            ],
            [
              80.3300777450437,
              6.165792754879234
            ],
            [
              80.3301496329671,
              6.165759767768648
            ],
            [
              80.33027681929389,
              6.165831239839207
            ],
            [
              80.3302989386545,
              6.1659906774995505
            ],
            [
              80.33044824434182,
              6.166045655992974
            ],
            [
              80.33056990082821,
              6.166111630176502
            ],
            [
              80.33071920651554,
              6.166128123720483
            ],
            [
              80.33090722108352,
              6.166084140934586
            ],
            [
              80.33103993725081,
              6.166078643085783
            ],
            [
              80.3312058324583,
              6.166018166746326
            ],
            [
              80.3312998397422,
              6.166029162445156
            ],
            [
              80.33136619782653,
              6.166122625872106
            ],
            [
              80.33150444383296,
              6.166216089283864
            ],
            [
              80.33167033904039,
              6.1662820634461895
            ],
            [
              80.33181411488732,
              6.1663480376003434
            ],
            [
              80.33191365201179,
              6.166436003127259
            ],
            [
              80.33209060690149,
              6.166501977262186
            ],
            [
              80.33223438274837,
              6.166529466482444
            ],
            [
              80.33229521099088,
              6.1666284276644205
            ],
            [
              80.33231180051092,
              6.166771371561694
            ],
            [
              80.33232286019188,
              6.166941804620649
            ],
            [
              80.33216249482496,
              6.166963795978461
            ],
            [
              80.33191365201179,
              6.167046263564487
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
    .doc("field-03");

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
