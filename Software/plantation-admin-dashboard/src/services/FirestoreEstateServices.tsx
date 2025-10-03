import { doc, getDoc, collection, getDocs, Timestamp, where } from "firebase/firestore";
import { db } from "../utils/firebase";
import { orderBy, query } from "firebase/firestore";

// Fetch all estates (states)
export const fetchAllStates = async () => {
  const snapshot = await getDocs(collection(db, "states"));
  return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
};

// Fetch single state details
export const fetchStateDetails = async (stateId: string) => {
  const stateDoc = await getDoc(doc(db, "states", stateId));
  return stateDoc.exists() ? { id: stateDoc.id, ...stateDoc.data() } : null;
};

// Fetch sections of a state
export const fetchSections = async (stateId: string) => {
  const sectionSnapshot = await getDocs(collection(db, "states", stateId, "sections"));

  return Promise.all(sectionSnapshot.docs.map(async (sectionDoc) => {
    const sectionData = sectionDoc.data();
    const fieldsSnapshot = await getDocs(collection(db, "states", stateId, "sections", sectionDoc.id, "fields"));
    
    const fields = fieldsSnapshot.docs.map(fieldDoc => {
      const fieldData = fieldDoc.data();
      return {
        id: fieldDoc.id,
        name: fieldData.fieldName ?? "Unnamed Field", // Map `fieldName` to `name`
      };
    });

    return {
      id: sectionDoc.id,
      name: sectionData.sectionName ?? "Unnamed Section", // Map `sectionName` to `name`
      fields,
    };
  }));
};


// Fetch the readings for the charts

// export const fetchFieldReadings = async (stateId: string, sectionId: string, fieldId: string) => {
//   const readingsRef = collection(db, "states", stateId, "sections", sectionId, "fields", fieldId, "readings");
//   const q = query(readingsRef, orderBy("timestamp", "asc")); // order by time

//   const snapshot = await getDocs(q);
//   return snapshot.docs.map(doc => {
//     const data = doc.data();
//     return {
//       id: doc.id,
//       timestamp: data.timestamp?.toDate(), // convert Firestore timestamp to JS Date
//       nitrogen: data.nitrogen,
//       phosphorus: data.phosphorus,
//       potassium: data.potassium,
//       soilMoisture: data.soilMoisture,
//     };
//   });
// };

// export const fetchFieldReadings = async (stateId: string, sectionId: string, fieldId: string) => {
//   const readingsRef = collection(
//     db,
//     "states",
//     stateId,
//     "sections",
//     sectionId,
//     "fields",
//     fieldId,
//     "readings"
//   );

//   const q = query(readingsRef, orderBy("timestamp", "asc"));
//   const snapshot = await getDocs(q);

//   return snapshot.docs.map(doc => {
//     const data = doc.data();
//     const npk = data.npk || {}; // fallback to empty object

//     return {
//       id: doc.id,
//       timestamp: data.timestamp?.toDate(),
//       nitrogen: npk.nitrogen ?? 0,
//       phosphorus: npk.phosphorus ?? 0,
//       potassium: npk.potassium ?? 0,
//       soilMoisture: data.soilMoisture ?? 0,
//     };
//   });
// };

export const fetchFieldReadings = async (
  stateId: string,
  sectionId: string,
  fieldId: string
) => {
  const readingsRef = collection(
    db,
    "states",
    stateId,
    "sections",
    sectionId,
    "fields",
    fieldId,
    "readings"
  );

  const q = query(readingsRef, orderBy("timestamp", "asc"));
  const snapshot = await getDocs(q);

  const readings = snapshot.docs.map(doc => {
    const data = doc.data();
    const npk = data.npk || {}; // fallback to empty object

    return {
      id: doc.id,
      timestamp: data.timestamp?.toDate(),
      nitrogen: npk.nitrogen ?? null,
      phosphorus: npk.phosphorus ?? null,
      potassium: npk.potassium ?? null,
      soilMoisture: data.soilMoisture ?? null,
    };
  });

  return readings;
};


// Utility function to filter data for plotting a specific field
export const prepareChartData = (
  readings: any[],
  field: "soilMoisture" | "nitrogen" | "phosphorus" | "potassium"
) => {
  return readings
    .filter(r => r[field] !== null) // remove missing values
    .map(r => ({
      name: r.timestamp?.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }),
      value: r[field],
    }));
};


export const fetchFieldReadingsLast30Days = async (
  stateId: string,
  sectionId: string,
  fieldId: string
) => {
  const readingsRef = collection(
    db,
    "states",
    stateId,
    "sections",
    sectionId,
    "fields",
    fieldId,
    "readings"
  );

  // calculate 30 days ago timestamp
  const thirtyDaysAgo = new Date();
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

  const q = query(
    readingsRef,
    where("timestamp", ">=", Timestamp.fromDate(thirtyDaysAgo)),
    orderBy("timestamp", "asc")
  );

  const snapshot = await getDocs(q);

  const readings = snapshot.docs.map(doc => {
    const data = doc.data();
    const npk = data.npk || {};

    return {
      id: doc.id,
      timestamp: data.timestamp?.toDate(),
      nitrogen: npk.nitrogen ?? null,
      phosphorus: npk.phosphorus ?? null,
      potassium: npk.potassium ?? null,
      soilMoisture: data.soilMoisture ?? null,
    };
  });

  return readings;
};

export const fetchRainfallLast7Days = async () => {
  const rainfallRef = collection(db, "rainfall_readings");

  // Calculate timestamp 7 days ago
  const sevenDaysAgo = new Date();
  sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

  const q = query(
    rainfallRef,
    where("timestamp", ">=", Timestamp.fromDate(sevenDaysAgo)),
    orderBy("timestamp", "asc")
  );

  const snapshot = await getDocs(q);

  const readings = snapshot.docs.map(doc => {
    const data = doc.data();
    return {
      id: doc.id,
      timestamp: data.timestamp?.toDate(),
      rainfall: data.rainfall ?? null,
      tipCount: data.tipCount ?? null,
    };
  });

  return readings;
};



export const fetchLuxLevelLast7Days = async () => {
  const luxRef = collection(db, "lux_level");

  // Timestamp 7 days ago
  const sevenDaysAgo = new Date();
  sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

  const q = query(
    luxRef,
    where("timestamp", ">=", Timestamp.fromDate(sevenDaysAgo)),
    orderBy("timestamp", "asc")
  );

  const snapshot = await getDocs(q);

  const readings = snapshot.docs.map(doc => {
    const data = doc.data();
    return {
      id: doc.id,
      timestamp: data.timestamp?.toDate(),
      humidity: data.humidity ?? null,
      lux: data.lux ?? null,
      temperature: data.temperature ?? null,
    };
  });

  return readings;
};













export const calculateFieldAverages = (readings: any[]) => {
  if (readings.length === 0) return null;

  const sum = readings.reduce(
    (acc, r) => {
      if (r.nitrogen !== null) acc.nitrogen += r.nitrogen;
      if (r.phosphorus !== null) acc.phosphorus += r.phosphorus;
      if (r.potassium !== null) acc.potassium += r.potassium;
      if (r.soilMoisture !== null) acc.soilMoisture += r.soilMoisture;
      return acc;
    },
    { nitrogen: 0, phosphorus: 0, potassium: 0, soilMoisture: 0 }
  );

  const count = readings.reduce(
    (acc, r) => {
      if (r.nitrogen !== null) acc.nitrogen += 1;
      if (r.phosphorus !== null) acc.phosphorus += 1;
      if (r.potassium !== null) acc.potassium += 1;
      if (r.soilMoisture !== null) acc.soilMoisture += 1;
      return acc;
    },
    { nitrogen: 0, phosphorus: 0, potassium: 0, soilMoisture: 0 }
  );

  return {
    nitrogen: count.nitrogen ? sum.nitrogen / count.nitrogen : null,
    phosphorus: count.phosphorus ? sum.phosphorus / count.phosphorus : null,
    potassium: count.potassium ? sum.potassium / count.potassium : null,
    soilMoisture: count.soilMoisture ? sum.soilMoisture / count.soilMoisture : null,
  };
};


export const calculateAverageRainfall = (readings: any[]) => {
  if (readings.length === 0) return null;

  const sum = readings.reduce((acc, r) => {
    if (r.rainfall !== null) acc += r.rainfall;
    return acc;
  }, 0);

  const count = readings.filter(r => r.rainfall !== null).length;

  return count ? sum / count : null;
};


export const calculateLuxLevelAverages = (readings: any[]) => {
  if (readings.length === 0) return null;

  const sum = readings.reduce(
    (acc, r) => {
      if (r.humidity !== null) acc.humidity += r.humidity;
      if (r.lux !== null) acc.lux += r.lux;
      if (r.temperature !== null) acc.temperature += r.temperature;
      return acc;
    },
    { humidity: 0, lux: 0, temperature: 0 }
  );

  const count = readings.reduce(
    (acc, r) => {
      if (r.humidity !== null) acc.humidity += 1;
      if (r.lux !== null) acc.lux += 1;
      if (r.temperature !== null) acc.temperature += 1;
      return acc;
    },
    { humidity: 0, lux: 0, temperature: 0 }
  );

  return {
    humidity: count.humidity ? sum.humidity / count.humidity : null,
    lux: count.lux ? sum.lux / count.lux : null,
    temperature: count.temperature ? sum.temperature / count.temperature : null,
  };
};
