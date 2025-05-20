import { onDocumentCreated } from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";
import * as turf from "@turf/turf";
import { onSchedule } from "firebase-functions/v2/scheduler";


// To find the related filed according to the geopoint0
// Make sure this matches your local project ID in .firebaserc or Firebase Emulator
admin.initializeApp({
  projectId: "environment-monitoring-s-d169b", // <-- 🔁 Replace with your actual project ID
});

const firestore = admin.firestore();

export const processAndStoreRawReading = onDocumentCreated("raw_readings/{readingId}", async (event) => {
  const snapshot = event.data;

  if (!snapshot) {
    logger.warn("No data in snapshot.");
    return;
  }

  const data = snapshot.data();
  const { soilMoisture, nitrogen, phosphorus, potassium, geoPoint, timestamp } = data;

  if (!geoPoint || geoPoint.latitude === undefined || geoPoint.longitude === undefined) {
    logger.warn("Invalid GeoPoint in raw reading.");
    return;
  }

  const rawPoint: [number, number] = [geoPoint.longitude, geoPoint.latitude];
  const statesSnapshot = await firestore.collection("states").get();

  let matchedFieldRef: FirebaseFirestore.DocumentReference | null = null;
  let matchedStateId = "";
  let matchedSectionId = "";
  let matchedFieldId = "";
  let matchedStateName = "";
  let matchedSectionName = "";

  try {
    for (const stateDoc of statesSnapshot.docs) {
      const stateId = stateDoc.id;
      const stateData = stateDoc.data();
      const stateName = stateData.stateName ?? "Unknown State";
      const sectionsSnapshot = await stateDoc.ref.collection("sections").get();

      for (const sectionDoc of sectionsSnapshot.docs) {
        const sectionId = sectionDoc.id;
        const sectionData = sectionDoc.data();
        const sectionName = sectionData.sectionName ?? "Unknown Section";
        const fieldsSnapshot = await sectionDoc.ref.collection("fields").get();

        for (const fieldDoc of fieldsSnapshot.docs) {
          const fieldId = fieldDoc.id;
          const fieldData = fieldDoc.data();
          const boundary = fieldData.boundary;

          if (
            !boundary ||
            boundary.type !== "Polygon" ||
            !Array.isArray(boundary.coordinates)
          ) {
            continue;
          }

          const coords = boundary.coordinates.map((pt: admin.firestore.GeoPoint) => [pt.longitude, pt.latitude]);
          const closedCoords =
            coords[0][0] === coords[coords.length - 1][0] && coords[0][1] === coords[coords.length - 1][1]
              ? coords
              : [...coords, coords[0]];

          const turfPolygon = turf.polygon([closedCoords]);
          const turfPoint = turf.point(rawPoint);

          if (turf.booleanPointInPolygon(turfPoint, turfPolygon)) {
            matchedFieldRef = fieldDoc.ref;
            matchedStateId = stateId;
            matchedSectionId = sectionId;
            matchedFieldId = fieldId;
            matchedStateName = stateName;
            matchedSectionName = sectionName;
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

    // ✅ Save reading under field
    await matchedFieldRef.collection("readings").add({
      soilMoisture,
      npk: {
        nitrogen,
        phosphorus,
        potassium,
      },
      timestamp: timestamp ?? admin.firestore.Timestamp.now(),
    });

    // ✅ Save to latest collection
    const latestRef = firestore.collection("latest").doc();
    await latestRef.set({
      stateId: matchedStateId,
      sectionId: matchedSectionId,
      fieldId: matchedFieldId,
      stateName: matchedStateName,
      sectionName: matchedSectionName,
      timestamp: timestamp ?? admin.firestore.Timestamp.now(),
    });

    logger.info(`Reading processed for field ${matchedFieldRef.path}`);
  } catch (error) {
    logger.error("Error processing raw reading:", error);
  }
});



/////////////////////////////////////////////////////////////////////////////////////
// Rainfall calculation

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
export const generateDailySoilSummary = onSchedule("every day 01:00", async () => {
  await generateSummaryLogic();
});

// Separate the logic into a callable function
export async function generateSummaryLogic() {
  const statesSnapshot = await firestore.collection("states").get();

  for (const stateDoc of statesSnapshot.docs) {
    const sectionsSnapshot = await stateDoc.ref.collection("sections").get();

    for (const sectionDoc of sectionsSnapshot.docs) {
      const fieldsSnapshot = await sectionDoc.ref.collection("fields").get();

      for (const fieldDoc of fieldsSnapshot.docs) {
        const start = admin.firestore.Timestamp.fromDate(new Date(Date.now() - 86400000)); // 24 hrs
        const readings = await fieldDoc.ref
          .collection("readings")
          .where("timestamp", ">=", start)
          .get();

        if (!readings.empty) {
          let moistureTotal = 0, n = 0, p = 0, k = 0;
          readings.forEach(doc => {
            const d = doc.data();
            moistureTotal += d.soilMoisture;
            n += d.npk.nitrogen;
            p += d.npk.phosphorus;
            k += d.npk.potassium;
          });

          const count = readings.size;

          await fieldDoc.ref.collection("summaries").doc("daily").set({
            date: new Date().toISOString().split("T")[0],
            avgSoilMoisture: +(moistureTotal / count).toFixed(2),
            avgNitrogen: +(n / count).toFixed(2),
            avgPhosphorus: +(p / count).toFixed(2),
            avgPotassium: +(k / count).toFixed(2),
          });
        }
      }
    }
  }
}
