import { doc, getDoc, collection, getDocs } from "firebase/firestore";
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
