import React from "react";

type EstateCardProps = {
  imageUrl: string;
  name: string;
  description?: string;
  owner?: string;
  onClick?: () => void;
};

export default function EstateCard({
  imageUrl,
  name,
  description,
  owner,
  onClick,
}: EstateCardProps) {
  return (
    <div
      className="
        rounded-3xl
        overflow-hidden
        bg-gray-50
        shadow-md
        transition-all
        duration-200
        cursor-pointer
        max-w-xs
        min-w-[260px]
        flex
        flex-col
      "
      onClick={onClick}
    >
      {/* Estate image */}
      <div className="h-36 w-full rounded-t-3xl">
        <img
          src={imageUrl}
          alt={name}
          className="w-full h-full object-cover"
        />
      </div>
      {/* Estate info */}
      <div className="p-4 flex flex-col flex-1">
        <div className="flex items-center gap-2 mb-2">
          <span className="bg-blue-100 text-blue-700 px-3 py-1 rounded-full text-xs font-semibold">
            {owner || "Estate"}
          </span>
        </div>
        <div className="font-bold text-lg text-gray-800 mb-1">{name}</div>
        <div className="text-gray-500 text-sm flex-1">{description || ""}</div>
      </div>
    </div>
  );
}
