import { jQuery, $ } from "jquery";
import "leaflet";
import "leaflet-iiif";

const viewers = document.querySelectorAll("[data-viewer-leaflet]");

viewers.forEach(elem => {
  const url = elem.getAttribute("data-viewer-leaflet");
  const map = L.map(elem, {
    center: [0, 0],
    crs: L.CRS.Simple,
    zoom: 0
  });

  L.tileLayer.iiif(url).addTo(map);
});
