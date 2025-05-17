import { onDocumentCreated } from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";
import * as turf from "@turf/turf";

// Make sure this matches your local project ID in .firebaserc or Firebase Emulator
admin.initializeApp({
  projectId: "environment-monitoring-s-d169b", // <-- 🔁 Replace with your actual project ID
});

const firestore = admin.firestore();


export const processRawReading = onDocumentCreated("raw_readings/{readingId}", async (event) => {
  const snapshot = event.data;

  if (!snapshot) {
    logger.warn("No data in snapshot.");
    return;
  }

  const data = snapshot.data();
  // const { soilMoisture, nitrogen, phosphorus, potassium, geoPoint } = data;

  const { soilMoisture, nitrogen, phosphorus, potassium, geoPoint, timestamp } = data;


  if (!geoPoint || geoPoint.latitude === undefined || geoPoint.longitude === undefined) {
    logger.warn("Invalid GeoPoint in raw reading.");
    return;
  }

  
  const rawPoint: [number, number] = [geoPoint.longitude, geoPoint.latitude];
  logger.debug("Converted GeoPoint to [lng, lat]:", rawPoint);
  console.log("Converted GeoPoint to [lng, lat]:", rawPoint);

  try {
    console.log("Inside try block before fetching states");

    // Optional debug to list all top-level collections
    const collections = await firestore.listCollections();
    console.log("Top-level collections in Firestore:");
    collections.forEach(col => console.log(col.id));

    const statesSnapshot = await firestore.collection("states").get();
    logger.debug(`Fetched ${statesSnapshot.docs.length} states.`);
    console.log(`Fetched ${statesSnapshot.docs.length} states.`);

    let matchedFieldRef: FirebaseFirestore.DocumentReference | null = null;

    for (const stateDoc of statesSnapshot.docs) {
      const sectionsSnapshot = await stateDoc.ref.collection("sections").get();

      for (const sectionDoc of sectionsSnapshot.docs) {
        const fieldsSnapshot = await sectionDoc.ref.collection("fields").get();

        for (const fieldDoc of fieldsSnapshot.docs) {
          const fieldData = fieldDoc.data();
          const boundary = fieldData.boundary;

          if (
            !boundary ||
            boundary.type !== "Polygon" ||
            !Array.isArray(boundary.coordinates)
          ) {
            logger.warn(`Field ${fieldDoc.id} has invalid or missing boundary.`);
            continue;
          }

          const polygonCoords = boundary.coordinates.map((pt: admin.firestore.GeoPoint) => {
            return [pt.longitude, pt.latitude]; // Convert GeoPoint to [lng, lat]
          });

          if (polygonCoords.length < 3) {
            logger.warn(`Field ${fieldDoc.id} polygon has less than 3 points.`);
            continue;
          }

          // Ensure polygon is closed
          const first = polygonCoords[0];
          const last = polygonCoords[polygonCoords.length - 1];
          const closedCoords =
            first[0] === last[0] && first[1] === last[1]
              ? polygonCoords
              : [...polygonCoords, first];

          const turfPolygon = turf.polygon([closedCoords]);
          const turfPoint = turf.point(rawPoint);

          const isInside = turf.booleanPointInPolygon(turfPoint, turfPolygon, {
            ignoreBoundary: false,
          });

          logger.warn(`Is raw reading inside field ${fieldDoc.id}?`, isInside);
          console.log(`Is raw reading inside field ${fieldDoc.id}?`, isInside);

          if (isInside) {
            matchedFieldRef = fieldDoc.ref;
            break;
          }
        }

        if (matchedFieldRef) break;
      }

      if (matchedFieldRef) break;
    }

    if (!matchedFieldRef) {
      logger.warn("No matching field found for GeoPoint:", geoPoint);
      return;
    }

    // await matchedFieldRef.update({
    //   soilMoisture,
    //   npk: {
    //     nitrogen,
    //     phosphorus,
    //     potassium,
    //   },
    // });

    
    await matchedFieldRef.collection("readings").add({
    soilMoisture,
    npk: {
      nitrogen,
      phosphorus,
      potassium,
    },
    timestamp, 
});


    logger.info(`Reading updated in field: ${matchedFieldRef.path}`);
  } catch (error) {
    logger.error("Error processing raw reading:", error);
  }
});



/////////////////////////////////////////////////////////////////////////////////////
// Rainfall

// Rainfall per tip (in mm)
const mmPerTip = 0.2;

export const processRainReading = onDocumentCreated("raw_rain_data/{readingId}", async (event) => {
  const snapshot = event.data;

  if (!snapshot) {
    logger.warn("No data in rainfall snapshot.");
    return;
  }

  const data = snapshot.data();
  const { tipCount, timestamp } = data;

  if (typeof tipCount !== "number" || tipCount < 0) {
    logger.warn("Invalid or missing tipCount in rain data.");
    return;
  }

  // const rainfall = tipCount * mmPerTip; // 0.2 mm per tip
  const rainfall = Math.round(tipCount * mmPerTip * 100) / 100;


  try {
    await firestore.collection("rainfall_readings").add({
      rainfall,
      tipCount,
      timestamp: timestamp ?? admin.firestore.Timestamp.now(),
    });

    logger.info(`🌧️ Rainfall recorded: ${rainfall} mm for ${tipCount} tips.`);
  } catch (error) {
    logger.error("❌ Error saving rainfall data:", error);
  }
});


  //////////////////////////////////////////////////////////////////



  