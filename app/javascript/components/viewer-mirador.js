import "../lib/mirador.js";

const selector = "data-viewer-mirador";
const viewers = document.querySelectorAll(`[${selector}]`);

viewers.forEach((elem, index) => {
  const id = `mirador-viewer-${index}`;
  const manifestUri = elem.getAttribute(selector);

  elem.setAttribute("id", id);
  Mirador({
    id: id,
    data: [
      {
        manifestUri: manifestUri
      }
    ]
  });
});
