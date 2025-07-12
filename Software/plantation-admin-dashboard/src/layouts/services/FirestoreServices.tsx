import { collection, query, orderBy, limit, getDocs } from "firebase/firestore";
import { db } from "../../utils/firebase";

export const fetchLatestSensorData = async () => {
  try {
    const q = query(
      collection(db, "lux_level"),
      orderBy("timestamp", "desc"),
      limit(1)
    );

    const querySnapshot = await getDocs(q);

    if (!querySnapshot.empty) {
      const doc = querySnapshot.docs[0];
      const data = doc.data();
      // Debugging purposes
      // console.warn(data);

      return {
        humidity: data.humidity ?? 0,
        lux: data.lux ?? 0,
        temperature: data.temperature ?? 0,
        timestamp: data.timestamp?.toDate?.().toString() ?? "", // Convert Firestore Timestamp to readable date
      };
    } else {
      console.warn("No sensor data found!");
      return null;
    }
  } catch (error) {
    console.error("Error fetching latest sensor data:", error);
    return null;
  }
};



// Develop this to get the average value of data for last 7 days for the cahrt diplayed in the dashboard
// ✅ New function for last 7 entries (used for chart)
export const fetchLast7SensorReadings = async () => {
  try {
    const q = query(
      collection(db, "lux_level"),
      orderBy("timestamp", "desc"),
      limit(7)
    );

    const querySnapshot = await getDocs(q);

    const readings = querySnapshot.docs.map((doc) => {
      const data = doc.data();
      return {
        humidity: data.humidity ?? 0,
        lux: data.lux ?? 0,
        temperature: data.temperature ?? 0,
        timestamp: data.timestamp?.toDate?.toLocaleString() ?? "",
      };
    });

    return readings.reverse(); // oldest to newest
  } catch (error) {
    console.error("Error fetching 7 sensor readings:", error);
    return [];
  }
};


