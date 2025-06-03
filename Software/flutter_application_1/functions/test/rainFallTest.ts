import * as admin from "firebase-admin";

// ✅ Tell Admin SDK to use Firestore Emulator
process.env.FIRESTORE_EMULATOR_HOST = "localhost:8080"; // or your emulator port

// Initialize Admin SDK for emulator use
if (!admin.apps.length) {
  admin.initializeApp({
    projectId: "environment-monitoring-s-d169b",
  });
}

const firestore = admin.firestore();

/**
 * Simulates a rain sensor sending tip count.
 * @param tipCount Number of tips recorded by the device.
 */
async function simulateRainReading(tipCount: number): Promise<void> {
  try {
    const readingRef = firestore.collection("raw_rain_data").doc();

    await readingRef.set({
      tipCount: tipCount,
      timestamp: admin.firestore.Timestamp.now(),
    });

    console.log(`✅ Simulated reading written: tipCount = ${tipCount}`);
  } catch (error) {
    console.error("❌ Error writing rain reading:", error);
  }
}

// Example usage
simulateRainReading(13).then(() => process.exit(0));
