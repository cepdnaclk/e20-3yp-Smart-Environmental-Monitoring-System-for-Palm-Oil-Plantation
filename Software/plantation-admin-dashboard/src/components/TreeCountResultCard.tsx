interface Props {
  entry: {
    inputImageUrl: string;
    outputImageUrl: string;
    treeCount: number;
    healthy: number;
    unhealthy: number;
  };
}

export default function AnalysisResultCard({ entry }: Props) {
  return (
    <div className="border rounded-lg p-4 shadow bg-white">
      <div className="flex flex-col gap-2 mt-2">
        <img
          src={entry.inputImageUrl}
          alt="Input"
          className="w-full h-40 object-cover rounded border"
        />
        <img
          src={entry.outputImageUrl}
          alt="Output"
          className="w-full h-40 object-cover rounded border"
        />
      </div>
      <div className="mt-3 space-y-1">
        <p>🌳 Total Trees: <strong>{entry.treeCount}</strong></p>
        <p className="text-green-600">✅ Healthy: {entry.healthy}</p>
        <p className="text-red-500">⚠️ Unhealthy: {entry.unhealthy}</p>
      </div>
    </div>
  );
}
