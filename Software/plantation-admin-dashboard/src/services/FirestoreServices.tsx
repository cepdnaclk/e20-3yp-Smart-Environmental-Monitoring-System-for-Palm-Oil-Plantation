// src/layouts/services/FirestoreServices.ts
import { collection, query, orderBy, limit, getDocs } from "firebase/firestore";
import { db } from "../utils/firebase";
import { onSnapshot} from "firebase/firestore";
import { doc, getDoc } from "firebase/firestore";

// Get latest one for lux, humidity and temperature
export const listenToLatestSensorData = (callback: (data: any) => void) => {
  const q = query(collection(db, "lux_level"), orderBy("timestamp", "desc"), limit(1));

  return onSnapshot(q, (snapshot) => {
    if (!snapshot.empty) {
      const doc = snapshot.docs[0];
      const data = doc.data();
      callback({
        humidity: data.humidity ?? 0,
        lux: data.lux ?? 0,
        temperature: data.temperature ?? 0,
        timestamp: data.timestamp?.toDate?.().toString() ?? "",
      });
    }
  });
};

// Get latest rainfall reading
export const listenToLatestRainfallData = (callback: (data: any) => void) => {
  const q = query(collection(db, "rainfall_readings"), orderBy("timestamp", "desc"), limit(1));

  return onSnapshot(q, (snapshot) => {
    if (!snapshot.empty) {
      const doc = snapshot.docs[0];
      const data = doc.data();
      callback({
        rainfall: data.rainfall ?? 0,
        tipCount: data.tipCount ?? 0,
        timestamp: data.timestamp?.toDate?.().toString() ?? "",
      });
    }
  });
};



// Get last 7 values for charting
// Real-time listener for last 7 sensor readings
export const listenToLast7SensorReadings = (callback: (data: any[]) => void) => {
  const q = query(
    collection(db, "lux_level"),
    orderBy("timestamp", "desc"),
    limit(7)
  );

  return onSnapshot(q, (snapshot) => {
    const readings = snapshot.docs.map((doc) => {
      const data = doc.data();
      return {
        humidity: data.humidity ?? 0,
        lux: data.lux ?? 0,
        temperature: data.temperature ?? 0,
        timestamp: data.timestamp?.toDate?.().toLocaleString() ?? "",
      };
    });

    callback(readings.reverse()); // from oldest to newest
  });
};

// Real-time listener for last 7 rainfall values
export const listenToLast7RainfallReadings = (callback: (data: any[]) => void) => {
  const q = query(
    collection(db, "rainfall_readings"),
    orderBy("timestamp", "desc"),
    limit(7)
  );

  return onSnapshot(q, (snapshot) => {
    const readings = snapshot.docs.map((doc) => {
      const data = doc.data();
      return {
        rainfall: data.rainfall ?? 0,
        tipCount: data.tipCount ?? 0,
        timestamp: data.timestamp?.toDate?.toLocaleString() ?? "",
      };
    });

    callback(readings.reverse()); // Oldest -> Newest
  });
};


// Fetch data for recent activities
// Listen to all documents in the 'latest' collection in real time
export const listenToRecentReadings = (callback: (readings: any[]) => void) => {
  const q = query(collection(db, "latest"), orderBy("timestamp", "desc"));

  return onSnapshot(q, (snapshot) => {
    const readings = snapshot.docs.map((doc) => {
      const data = doc.data();
      return {
        estate: data.stateName ?? "Unknown Estate",
        section: data.sectionName ?? "Unknown Section",
        datetime: data.timestamp?.toDate()?.toLocaleString(),
      };
    });

    callback(readings);
  });
};


// To fetch the data about the estates
export const fetchEstatesByIds = async (ids: string[]) => {
  try {
    const estatePromises = ids.map(async (id) => {
      const docRef = doc(db, "states", id);
      const docSnap = await getDoc(docRef);

      if (docSnap.exists()) {
        return {
          id,
          ...docSnap.data(),
        };
      } else {
        console.warn(`Estate document with ID ${id} not found`);
        return null;
      }
    });

    const estates = await Promise.all(estatePromises);
    return estates.filter((e) => e !== null); // remove nulls if any doc is missing
  } catch (error) {
    console.error("Error fetching estates:", error);
    return [];
  }
};
