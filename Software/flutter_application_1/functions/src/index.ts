import { onDocumentCreated } from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";
import * as turf from "@turf/turf";
import { onCall } from "firebase-functions/v2/https";
import * as stats from "simple-statistics";
import { Timestamp } from "firebase-admin/firestore";


// To find the related filed according to the geopoint0
// Make sure this matches your local project ID in .firebaserc or Firebase Emulator
// admin.initializeApp();

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
    // Finding the related state- section and field
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

    // // ✅ Save reading under field
    // // In the subcollection called "readings"
    // await matchedFieldRef.collection("readings").add({
    //   soilMoisture,
    //   npk: {
    //     nitrogen,
    //     phosphorus,
    //     potassium,
    //   },
    //   timestamp: timestamp ?? admin.firestore.Timestamp.now(),
    // });

    // //To save newly coming reading under the sections collection
    // const sectionRef = firestore
    //   .collection("states")
    //   .doc(matchedStateId)
    //   .collection("sections")
    //   .doc(matchedSectionId);

    // await sectionRef.collection("sectionReadings").add({
    //   soilMoisture,
    //   npk: {
    //     nitrogen,
    //     phosphorus,
    //     potassium,
    //   },
    //   timestamp: timestamp ?? admin.firestore.Timestamp.now(),
    //   fieldId: matchedFieldId,
    //   fieldPath: matchedFieldRef.path,
    // });


    // // Set the latest attribute in the field
    // try {
    //   await matchedFieldRef.set({
    //     latestReading: {
    //       soilMoisture,
    //       npk: {
    //         nitrogen,
    //         phosphorus,
    //         potassium,
    //       },
    //       timestamp: timestamp ?? admin.firestore.Timestamp.now(),
    //       location: geoPoint,
    //     },
    //   }, { merge: true });
    //   logger.info("latestReading successfully updated.");
    // } catch (e) {
    //   logger.error("Failed to update latestReading:", e);
    // }


//     // ✅ Save to latest collection
//     // This is a collection in home directory
//     // This is used to fetch the recent activities
//     const latestRef = firestore.collection("latest").doc();
//     await latestRef.set({
//       stateId: matchedStateId,
//       sectionId: matchedSectionId,
//       fieldId: matchedFieldId,
//       stateName: matchedStateName,
//       sectionName: matchedSectionName,
//       timestamp: timestamp ?? admin.firestore.Timestamp.now(),
//     });

//     logger.info(`Reading processed for field ${matchedFieldRef.path}`);
//   } catch (error) {
//     logger.error("Error processing raw reading:", error);
//   }
// });




    // Build dynamic reading object
    const readingData: any = {
      timestamp: timestamp ?? admin.firestore.Timestamp.now(),
    };

    if (soilMoisture !== undefined && soilMoisture !== null && soilMoisture !== -1 && soilMoisture >= 0) {
      readingData.soilMoisture = soilMoisture;
    } else {
      logger.warn("Missing or invalid soilMoisture:", soilMoisture);
    }

    const npkData: any = {};

    if (nitrogen !== undefined && nitrogen !== null && nitrogen !== -1 && nitrogen >= 0) {
      npkData.nitrogen = nitrogen;
    } else {
      logger.warn("Missing or invalid nitrogen:", nitrogen);
    }

    if (phosphorus !== undefined && phosphorus !== null && phosphorus !== -1 && phosphorus >= 0) {
      npkData.phosphorus = phosphorus;
    } else {
      logger.warn("Missing or invalid phosphorus:", phosphorus);
    }

    if (potassium !== undefined && potassium !== null && potassium !== -1 && potassium >= 0) {
      npkData.potassium = potassium;
    } else {
      logger.warn("Missing or invalid potassium:", potassium);
    }

    if (Object.keys(npkData).length > 0) {
      readingData.npk = npkData;
    }

    // ✅ Save reading under field
    await matchedFieldRef.collection("readings").add(readingData);

    // ✅ Save under section
    const sectionRef = firestore
      .collection("states")
      .doc(matchedStateId)
      .collection("sections")
      .doc(matchedSectionId);

    await sectionRef.collection("sectionReadings").add({
      ...readingData,
      fieldId: matchedFieldId,
      fieldPath: matchedFieldRef.path,
    });

    // ✅ Update latestReading on field
    const latestReadingData: any = {
      timestamp: timestamp ?? admin.firestore.Timestamp.now(),
      location: geoPoint,
    };

    if (soilMoisture !== undefined && soilMoisture !== null && soilMoisture !== -1) {
      latestReadingData.soilMoisture = soilMoisture;
    }

    if (Object.keys(npkData).length > 0) {
      latestReadingData.npk = npkData;
    }

    try {
      await matchedFieldRef.set(
        { latestReading: latestReadingData },
        { merge: true }
      );
      logger.info("latestReading successfully updated.");
    } catch (e) {
      logger.error("Failed to update latestReading:", e);
    }

    // ✅ Save to 'latest' collection
    await firestore.collection("latest").doc().set({
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


//////////////////////////////////////////////////////////////////////////////////////
// Get the stats on the parameters sectionwise 
// This is triggering when the user is calling the function
export const getSectionParameterStatistics = onCall(async (request) => {
  const { sectionPath, parameter, startTime, endTime } = request.data;


  if (!sectionPath || !parameter) {
    throw new Error("Missing sectionPath or parameter");
  }

  const db = admin.firestore();
  const sectionRef = db.doc(sectionPath);
  const readingsRef = sectionRef.collection("sectionReadings");

  const now = Timestamp.now();
  const startTimestamp = startTime
    ? Timestamp.fromDate(new Date(startTime))
    : Timestamp.fromDate(new Date(now.toDate().getTime() - 30 * 24 * 60 * 60 * 1000));

  // logger.warn("StartTimestamp:", startTimestamp.toDate());

  const endTimestamp = endTime ? Timestamp.fromDate(new Date(endTime)) : now;
  // logger.warn("EndTimestamp:", endTimestamp.toDate());

  const snapshot = await readingsRef
    .where("timestamp", ">=", startTimestamp)
    .where("timestamp", "<=", endTimestamp)
    .orderBy("timestamp")
    .get();

  const readings = snapshot.docs.map(doc => doc.data());

  // logger.warn(`Got ${snapshot.size} documents in query result`);

  // snapshot.docs.forEach(doc => {
  //   const data = doc.data();
  //   logger.warn("Doc ID:", doc.id, "Timestamp:", data.timestamp);
  // });

  // logger.warn("Querying collection:", readingsRef.path);

  if (readings.length === 0) {
    return { message: "No data in this time range" };
  }

  

  // 🔍 Utility to extract nested parameter
  const getNested = (obj: any, path: string): number | null => {
    const parts = path.split(".");
    let val = obj;
    for (const part of parts) {
      if (!val || !(part in val)) return null;
      val = val[part];
    }
    return typeof val === "number" ? val : null;
  };

  const dataPoints = [];
  const values: number[] = [];

  for (const r of readings) {
    const v = getNested(r, parameter);
    if (v !== null) {
      values.push(v);
      dataPoints.push({
        timestamp: r.timestamp.toDate(),
        // To get the readable data and time
        // timestamp: r.timestamp.toDate().toISOString(),
        value: v
      });
    }
  }

  if (values.length === 0) {
    return { message: `No valid values found for parameter ${parameter}` };
  }

  const result = {
    parameter,
    count: values.length,
    mean: stats.mean(values),
    median: stats.median(values),
    mode: stats.mode(values),
    standardDeviation: stats.standardDeviation(values),
    variance: stats.variance(values),
    skewness: values.length >= 3 ? stats.sampleSkewness(values) : null,
    kurtosis: values.length >= 3 ? stats.sampleKurtosis(values) : null,
    min: Math.min(...values),
    max: Math.max(...values),
    dataPoints
  };

  return result;
});