import React, { useEffect, useState } from "react";
import { Link, useLocation } from "react-router-dom";
import { Tag } from "../Tag";
import { ItemImage } from "./ItemImage";

export function ItemTile(props) {
  const { keys, data, __title, item } = props;
  const title = data?.general?.title || __title;
  const [imageError, setImageError] = useState(false);
  const [isUser, setIsUser] = useState(false);
  const location = useLocation();

  useEffect(() => {
    const isShipUser = location.pathname.split("/")[3] === "usr";
    setIsUser(isShipUser);
  }, [location.pathname]);

  const formatAppUriKey = ({ keyStr, ship, type, cord }) => {
    const appUriKey = (
      keyStr ? keyStr.slice(1) : `${ship}${type}${cord?.replaceAll(".", "-")}`
    ).replaceAll("/", "_");

    return appUriKey;
  };
  const _getAppUriKey = ({ keyStr, keyObj }) => {
    return formatAppUriKey({ keyStr, ...keyObj });
  };
  const getKeys = _keys => ({
    keyStr: _keys?.keyStr || props.keyStr || props.item.keyStr,
    keyObj: _keys?.keyObj || props.keyObj || props.item.keyObj,
  });
  const getAppUriKey = _keys => _getAppUriKey(getKeys(_keys));
  const getItemType = () => props.itemType || data?.general?.type || "other";
  const getImage = () =>
    data?.general?.image || data?.icon?.src || data?.bespoke?.payload?.docket?.image;
  return data ? (
    <li className="flex items-center space-x-3 text-sm leading-tight">
      <Link
        to={`/apps/portal/${!isUser ? `dev` : `usr`}/apps/${getAppUriKey(keys)}`}
        className="w-full p-4 rounded border border-black hover:bg-gray-200"
      >
        <div className="flex flex-row flex-auto justify-between">
          <div className="flex flex-row">
            <div
              className="flex-none relative w-20 h-20 mr-10 rounded-lg bg-gray-200 overflow-hidden"
              style={{ backgroundColor: "aliceblue" }}
            >
              {!imageError ? (
                <ItemImage
                  src={getImage()}
                  type={getItemType()}
                  onError={setImageError}
                />
              ) : null}
            </div>
            <div className="flex flex-col space-y-3">
              <p className="text-2xl font-bold">{title}</p>
              {data?.general?.tags?.length ? (
                <ul className="flex flex-wrap gap-2">
                  {data.general.tags.map((tag, i) => (
                    <Tag key={`${title}_${tag}_${i}`} name={tag} />
                  ))}
                </ul>
              ) : null}
            </div>
          </div>
        </div>
      </Link>
      {!isUser ? (
        <div className="flex">
          <div className="relative">
            <Link
              to={`/apps/portal/dev/edit-app/${getAppUriKey(keys)}`}
              className="absolute right-32 top-0 mt-auto mb-auto ml-auto font-bold border-2 border-black hover:bg-gray-800 hover:text-white py-2 px-5"
            >
              edit
            </Link>
          </div>
        </div>
      ) : null}
    </li>
  ) : null;
}