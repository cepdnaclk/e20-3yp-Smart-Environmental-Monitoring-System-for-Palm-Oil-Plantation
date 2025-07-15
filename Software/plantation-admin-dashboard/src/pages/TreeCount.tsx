import React, { useState, useEffect } from "react";
import SidebarLayout from "../layouts/SidebarLayout";
import { listenToLatestTreeAnalysis, uploadAndAnalyzeTreeImage } from "../services/TreeAnalysisService";
import AnalysisResultCard from "../components/TreeCountResultCard";
import { fetchTreeAnalysisHistory } from "../services/FirestoreServices";

export default function TreeHealthAnalysis() {
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const [previewUrl, setPreviewUrl] = useState<string | null>(null);
  const [history, setHistory] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [analysisResult, setAnalysisResult] = useState<any | null>(null);
  const [unsubscribeListener, setUnsubscribeListener] = useState<(() => void) | null>(null);

  useEffect(() => {
    loadHistory();
  }, []);

  const loadHistory = async () => {
    const results = await fetchTreeAnalysisHistory(20); // Fetch latest 6
    setHistory(results);
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      setSelectedFile(file);
      setPreviewUrl(URL.createObjectURL(file));
      setAnalysisResult(null);
    }
  };

  // const handleUpload = async () => {
  //   if (!selectedFile) return;
  //   setIsLoading(true);

  //   try {
  //     const result = await uploadAndAnalyzeTreeImage(selectedFile);
  //     setAnalysisResult(result);
  //     await loadHistory();
  //     setSelectedFile(null);
  //     setPreviewUrl(null);
  //   } catch (error) {
  //     console.error("Upload failed:", error);
  //   } finally {
  //     setIsLoading(false);
  //   }
  // };


  

  const handleUpload = async () => {
    if (!selectedFile) return;
    setIsLoading(true);
    setAnalysisResult(null);

    try {
      // Start listening for the latest result
      const unsubscribe = listenToLatestTreeAnalysis((data) => {
        setAnalysisResult(data);
      });
      setUnsubscribeListener(() => unsubscribe);

      await uploadAndAnalyzeTreeImage(selectedFile);

      await loadHistory(); // update history list
      setSelectedFile(null);
      setPreviewUrl(null);
    } catch (error) {
      console.error("Upload failed:", error);
    } finally {
      setIsLoading(false);
    }
  };

  // 🧼 Optional: clean up the listener when component unmounts
  useEffect(() => {
    return () => {
      if (unsubscribeListener) {
        unsubscribeListener();
      }
    };
  }, [unsubscribeListener]);


  return (
    <SidebarLayout>
      <div className="p-6 max-w-6xl mx-auto">
        <h2 className="text-3xl font-bold mb-6">Tree Health Analyzer</h2>

        {/* Upload Section */}
        <div className="mb-6 border p-4 rounded-lg bg-white shadow">
          <label className="block font-medium mb-2">Upload Image</label>
          <input type="file" accept="image/*" onChange={handleFileChange} />

          {previewUrl && (
            <img
              src={previewUrl}
              alt="Preview"
              className="mt-4 max-h-64 border rounded-md object-contain"
            />
          )}

          <button
            onClick={handleUpload}
            disabled={isLoading || !selectedFile}
            className="mt-4 px-6 py-2 bg-green-600 text-white font-semibold rounded hover:bg-green-700 disabled:bg-gray-400"
          >
            {isLoading ? "Analyzing..." : "Upload & Analyze"}
          </button>
        </div>

        {/* Current Result */}
        {analysisResult && (
          <div className="mb-10">
            <h3 className="text-xl font-semibold mb-4">Latest Analysis</h3>
            <AnalysisResultCard entry={analysisResult} />
          </div>
        )}

        {/* History */}
        <div className="mt-10">
          <h3 className="text-xl font-semibold mb-4">Previous Analyses</h3>
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {history.map((entry, idx) => (
              <AnalysisResultCard key={idx} entry={entry} />
            ))}
          </div>
        </div>
      </div>
    </SidebarLayout>
  );
}
