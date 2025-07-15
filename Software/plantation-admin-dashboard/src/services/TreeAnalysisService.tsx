import { db } from "../utils/firebase";
import { collection, getDocs, limit } from "firebase/firestore";
import { query, orderBy,  onSnapshot } from "firebase/firestore";

// // // Replace this with your actual endpoint
// // const API_ENDPOINT = "https://tree-health-901340579460.us-central1.run.app/predict/";

// // Upload image and get analysis result
// export const uploadAndAnalyzeTreeImage = async (file: File) => {
//   const formData = new FormData();
//   formData.append("image", file);

// //   const response = await fetch(API_ENDPOINT, {
// //     method: "POST",
// //     body: formData,
// //   });

// await fetch("/predict", {
//   method: "POST",
//   body: formData,
// });


//   if (!response.ok) {
//     throw new Error("Failed to analyze image.");
//   }

//   const result = await response.json();

//   return {
//     inputImageUrl: result.input_image_url,
//     outputImageUrl: result.output_image_url,
//     treeCount: result.tree_count,
//     healthy: result.detection_summary?.Healthy ?? 0,
//     unhealthy: result.detection_summary?.Unhealthy ?? 0,
//   };
// };

export const uploadAndAnalyzeTreeImage = async (file: File) => {
  const formData = new FormData();
  formData.append("file", file);

  const response = await fetch("/predict", {
    method: "POST",
    body: formData,
  });

  if (!response.ok) {
    throw new Error("Failed to analyze image.");
  }

  const result = await response.json();

  return {
    inputImageUrl: result.input_image_url,
    outputImageUrl: result.output_image_url,
    treeCount: result.tree_count,
    healthy: result.detection_summary?.Healthy ?? 0,
    unhealthy: result.detection_summary?.Unhealthy ?? 0,
  };
};


// Fetch limited history from Firestore (without relying on timestamp)
export const fetchTreeAnalysisHistory = async (count = 20) => {
  try {
    const ref = collection(db, "tree_analysis");
    const snapshot = await getDocs(ref);

    const results = snapshot.docs
      .map((doc) => doc.data())
      .filter((d) => d?.input_image_url && d?.output_image_url) // only valid entries
      .slice(-count) // get the last `count` entries (not real-time order, just latest written)
      .reverse();

    return results.map((data) => ({
      inputImageUrl: data.input_image_url,
      outputImageUrl: data.output_image_url,
      treeCount: data.tree_count,
      healthy: data.detection_summary?.Healthy ?? 0,
      unhealthy: data.detection_summary?.Unhealthy ?? 0,
    }));
  } catch (error) {
    console.error("Failed to fetch tree analysis history:", error);
    return [];
  }
};


// Listen to the latest analysis result in real time
export const listenToLatestTreeAnalysis = (callback: (data: any) => void) => {
  const q = query(
    collection(db, "tree_analysis"),
    orderBy("input_image_url", "desc"), // or another available field
    limit(1)
  );

  return onSnapshot(q, (snapshot) => {
    if (!snapshot.empty) {
      const doc = snapshot.docs[0].data();
      callback({
        inputImageUrl: doc.input_image_url,
        outputImageUrl: doc.output_image_url,
        treeCount: doc.tree_count,
        healthy: doc.detection_summary?.Healthy ?? 0,
        unhealthy: doc.detection_summary?.Unhealthy ?? 0,
      });
    }
  });
};
