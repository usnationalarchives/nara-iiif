import { jQuery, $ } from "jquery";
import "leaflet";
import "leaflet-iiif";

const selector = "data-viewer-leaflet";
const viewers = document.querySelectorAll(`[${selector}]`);

viewers.forEach(elem => {
  const url = elem.getAttribute(selector);
  const map = L.map(elem, {
    center: [0, 0],
    crs: L.CRS.Simple,
    zoom: 0
  });

  L.tileLayer.iiif(url).addTo(map);
});
