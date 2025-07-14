import React, { useState } from "react";

type Field = { id: number; name: string };
type Section = { id: number; name: string; fields: Field[] };
type Props = {
  sections: Section[];
  selectedSectionId?: number | null;
  selectedFieldId?: number | null;
  onSelect: (sectionId: number, fieldId: number) => void;
  title?: string;
};

export default function EstateSidebar({
  sections,
  selectedSectionId,
  selectedFieldId,
  onSelect,
  title = "Sections",
}: Props) {
  const [openSection, setOpenSection] = useState<number | null>(null);

  return (
    <aside className="w-72 min-h-screen bg-white border-r shadow-md flex flex-col p-4">
      <div className="mb-6 font-bold text-lg text-gray-700">{title}</div>
      <nav className="flex flex-col gap-1">
        {sections.map(section => (
          <div key={section.id}>
            <button
              className="w-full flex justify-between items-center px-3 py-2 rounded-lg text-gray-700 font-semibold hover:bg-blue-50"
              onClick={() => setOpenSection(openSection === section.id ? null : section.id)}
            >
              <span>{section.name}</span>
              <span>{openSection === section.id ? "▲" : "▼"}</span>
            </button>
            {openSection === section.id && (
              <div className="ml-4 mt-2 flex flex-col gap-1">
                {section.fields.map(field => (
                  <button
                    key={field.id}
                    onClick={() => onSelect(section.id, field.id)}
                    className={
                      `text-left px-3 py-2 rounded font-semibold transition 
                      ${selectedFieldId === field.id
                        ? "bg-blue-900 text-white font-bold shadow"
                        : "text-black hover:bg-blue-100"}`
                    }
                  >
                    {field.name}
                  </button>
                ))}
              </div>
            )}
          </div>
        ))}
      </nav>
    </aside>
  );
}
