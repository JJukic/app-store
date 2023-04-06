import React, { useState, useEffect } from "react";
import { poke, api } from "@state/usePortal";
import { toast } from "react-toastify";
import { urbitTime, defaultGeneral } from "@utils/format";
import { useStore, refreshAppState } from "@state/store";

export const NewPostForm = () => {
  const [description, setDescription] = useState("");
  const refreshApp = useStore(refreshAppState);

  const savePost = async () => {
    const _d = description;
    setDescription("");
    toast.promise(
      poke({
        app: "portal-manager",
        mark: "portal-action",
        json: {
          "add-item-to-list": {
            "list-key": {
              ship: `~${api.ship}`,
              type: "/list/enditem/other",
              cord: "~2000.1.2", // the default list key
            },
            ship: `~${ship}`,
            type: "/enditem/other",
            text: urbitTime(Date.now()),
            general: { ...defaultGeneral, description: _d },
            "bespoke-input": { "enditem-other": "" },
          },
        },
      }).then(() => {
        setTimeout(refreshApp, 1000);
      }),
      {
        pending: "Posting...",
        success: "Done!",
      }
    );
  };

  return (
    <div className="flex flex-col items-end mb-4">
      <textarea
        className="bg-transparent border border-gray-600 w-full mb-3 text-white resize-none"
        onChange={e => {
          e.persist();
          setDescription(e.target.value);
        }}
        placeholder="share something"
        value={description}
      >
        {description}
      </textarea>
      <button className="bg-blue-500 text-white rounded-lg py-2 px-3" onClick={savePost}>
        Post
      </button>
    </div>
  );
};
