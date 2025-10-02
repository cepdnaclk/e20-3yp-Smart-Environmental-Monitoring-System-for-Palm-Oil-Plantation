import FieldListItem from "../FieldListItem";
import { mockEstate } from "@/lib/constants";

export default function FieldListItemExample() {
  const field = mockEstate.sections[0].fields[0];
  const section = mockEstate.sections[0];

  return (
    <div className="p-4 max-w-md space-y-2">
      <FieldListItem
        field={field}
        section={section}
        isSelected={true}
        onClick={() => console.log('Selected')}
      />
      <FieldListItem
        field={mockEstate.sections[0].fields[1]}
        section={section}
        isSelected={false}
        onClick={() => console.log('Selected')}
      />
    </div>
  );
}
