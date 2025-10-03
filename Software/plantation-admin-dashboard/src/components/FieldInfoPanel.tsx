import React from "react";

interface FieldInfoPanelProps {
  field: any | null;   // replace `any` with your Field type
  section: any | null; // replace `any` with your Section type
  isHighlighted: boolean;
}

export default function FieldInfoPanel({
  field,
  section,
  isHighlighted,
}: FieldInfoPanelProps) {
  if (!field) {
    return <div className="p-4 text-gray-500">No field selected</div>;
  }

  return (
    <div className="p-4">
      <h3 className="text-lg font-bold">{field.name}</h3>
      {section && <p className="text-sm text-gray-600">Section: {section.name}</p>}
      <p className="text-sm text-gray-600">Area: {field.area} ha</p>
      {isHighlighted && (
        <p className="text-green-600 font-semibold mt-2">This field is highlighted</p>
      )}
    </div>
  );
}