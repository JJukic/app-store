import { useEffect, useState } from "react";
import Urbit from "@urbit/http-api";
import { urbitConfig as config } from "../config";
import { handleEvent } from "./events";
import {
  onInitialLoad as _onInitialLoad,
  onUpdate as _onUpdate,
  useStore,
} from "./store";
import { generateActions } from "../urbit/pokes";
import { types } from "./faces";
import { scries } from "../urbit/scries";

export const usePortalSubscription = () => {
  const [ship, urbit] = useUrbit();
  const [portalSub, setPortalSub] = useState(null);
  const onInitialLoad = useStore(_onInitialLoad);
  const onUpdate = useStore(_onUpdate);

  useEffect(() => {
    if (urbit && ship && !portalSub) {
      const portalSub = getSubscription(
        urbit,
        handleEvent(urbit, { onInitialLoad, onUpdate })
      );
      setPortalSub(portalSub);
    }
    return () => {
      urbit?.unsubscribe(portalSub);
    };
  }, [ship]);
};

export const usePortal = () => {
  const [ship, urbit] = useUrbit();
  const actions = generateActions(urbit);
  return { urbit, ship, actions, scries, types };
};

export const useUrbit = () => {
  const [urbit, setUrbit] = useState(null);
  const [ship, setShip] = useState(null);

  useEffect(() => {
    if (!ship) {
      const urbit = getUrbitApi(config.desk);
      setUrbit(urbit);
      setShip(urbit.ship);
    }
  }, [ship]);
  return [ship, urbit];
};

export const getUrbitApi = (desk = config.desk) => {
  const api = new Urbit("", "", desk);
  api.ship = window.ship;
  return api;
};

export const getSubscription = (urbit, eventHandler = console.log) =>
  urbit.subscribe({
    ...subscription,
    ship: urbit.ship,
    event: eventHandler,
  });

export const subscription = {
  app: config.agent,
  path: config.path,
  ship: window?.ship || "",
  verbose: true,
  event: console.log,
  err: console.error,
  quit: console.error,
};
