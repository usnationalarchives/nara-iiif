//------------------------------------------------------------------------
// Critical JS that will be inlined in the <head>
//
// NOTE: This needs to be copied to html/shared/_critical-js.html
//------------------------------------------------------------------------
"use strict";

// Add user agent classes and check if web fonts have previously loaded
(function() {
  var ua = navigator.userAgent,
    d = document.documentElement,
    classes = d.className;

  // Replace 'no-js' class name with 'js'
  classes = classes.replace("no-js", "js");

  // Detect iOS (needed to disable zoom on form elements)
  // http://stackoverflow.com/questions/9038625/detect-if-device-is-ios/9039885#9039885
  if (/iPad|iPhone|iPod/.test(ua) && !window.MSStream) {
    classes += " ua-ios";

    // Add class for version of iOS
    var iosMatches = ua.match(/((\d+_?){2,3})\slike\sMac\sOS\sX/);
    if (iosMatches) {
      classes += " ua-ios-" + iosMatches[1]; // e.g. ua-ios-7_0_2
    }

    // Add class for Twitter app
    if (/Twitter/.test(ua)) {
      classes += " ua-ios-twitter";
    }

    // Add class for Chrome browser
    if (/CriOS/.test(ua)) {
      classes += " ua-ios-chrome";
    }
  }

  // Detect Android (needed to disable print links on old devices)
  // http://www.ainixon.me/how-to-detect-android-version-using-js/
  if (/Android/.test(ua)) {
    var aosMatches = ua.match(/Android\s([0-9.]*)/);
    classes += aosMatches
      ? " ua-aos ua-aos-" + aosMatches[1].replace(/\./g, "_")
      : " ua-aos";
  }

  // Detect webOS (needed to disable optimizeLegibility)
  if (/webOS|hpwOS/.test(ua)) {
    classes += " ua-webos";
  }

  // Detect Samsung Internet browser
  if (/SamsungBrowser/.test(ua)) {
    classes += " ua-samsung";
  }

  // Check if “font-display” is supported, but only if fonts haven’t previously loaded
  if (typeof sessionStorage !== "undefined" && !sessionStorage.fontsLoaded) {
    // Use try/catch since IE 8- doesn’t support cssRules (but it does support sessionStorage)
    try {
      var isFontDisplaySupported =
        document
          .getElementById("cssTest")
          .sheet.cssRules[0].cssText.indexOf("font-display") !== -1;

      if (isFontDisplaySupported) {
        sessionStorage.fontsLoaded = "true";
      } else {
        console.log("no font-display support");
      }
    } catch (e) {
      // IE 8 will fail
    }
  }

  // If no sessionStorage support (i.e. IE 7-, Opera Mini), add "fonts-loaded" class immediately (may cause FOUC)
  // http://caniuse.com/#feat=namevalue-storage
  // If “sessionStorage.fontsLoaded” exists, assume fonts are cached and add class imediately
  if (typeof sessionStorage == "undefined" || !!sessionStorage.fontsLoaded) {
    classes += " fonts-loaded";
  }

  // Detect “object-fit” support
  // Note: Edge 16+ only support “object-fit” on img tags, but that’s all we’re using it for.
  // https://github.com/constancecchen/object-fit-polyfill
  // if ("objectFit" in document.documentElement.style === false) {
  //   classes += " no-objectfit";
  // }

  // Add classes
  d.className = classes;
})();
