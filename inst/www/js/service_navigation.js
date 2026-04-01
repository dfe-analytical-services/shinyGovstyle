
// Service navigation JS

// Allow programmatic update of active nav item from R server code
Shiny.addCustomMessageHandler("update_service_navigation", function (inputId) {
  var items = document.getElementsByClassName(
    "govuk-service-navigation__item"
  );

  for (var i = 0; i < items.length; i++) {
    items[i].classList.remove(
      "govuk-service-navigation__item--active"
    );
  }

  var link = document.getElementById(inputId);
  if (link) {
    var item = link.closest(".govuk-service-navigation__item");
    if (item) {
      item.classList.add("govuk-service-navigation__item--active");
    }
  }
});

// Set active state on navigation links when clicked
// Scoped to links within the list to avoid matching the service name link
$(document).on(
  "click",
  ".govuk-service-navigation__list .govuk-service-navigation__link",
  function () {
    var items = document.getElementsByClassName(
      "govuk-service-navigation__item"
    );

    for (var i = 0; i < items.length; i++) {
      items[i].classList.remove(
        "govuk-service-navigation__item--active"
      );
    }

    this.closest(
      ".govuk-service-navigation__item"
    ).classList.add(
      "govuk-service-navigation__item--active"
    );
  }
);

// Mobile menu toggle for service navigation
// Mirrors GDS govuk-service-navigation JS module behaviour:
// - On small screens: show toggle button, hide nav list
// - On large screens (>=48.0625em): hide toggle, show list
$(document).ready(function () {
  var MOBILE_BREAKPOINT = 769;

  var toggle = document.querySelector(
    ".govuk-service-navigation__toggle"
  );
  var navList = document.getElementById("navigation");

  if (!toggle || !navList) return;

  var wasMobile = false;

  function updateNavForViewport() {
    var isMobile = window.innerWidth < MOBILE_BREAKPOINT;

    if (isMobile && !wasMobile) {
      // Entering mobile: show toggle, collapse menu
      toggle.removeAttribute("hidden");
      toggle.setAttribute("aria-expanded", "false");
      navList.setAttribute("hidden", "");
    } else if (!isMobile && wasMobile) {
      // Entering desktop: hide toggle, show full list
      toggle.setAttribute("hidden", "");
      navList.removeAttribute("hidden");
    }

    wasMobile = isMobile;
  }

  // Set initial state
  wasMobile = window.innerWidth < MOBILE_BREAKPOINT;
  if (wasMobile) {
    toggle.removeAttribute("hidden");
    toggle.setAttribute("aria-expanded", "false");
    navList.setAttribute("hidden", "");
  } else {
    toggle.setAttribute("hidden", "");
    navList.removeAttribute("hidden");
  }

  $(window).on("resize", function () {
    updateNavForViewport();
  });

  $(toggle).on("click", function () {
    var expanded = toggle.getAttribute(
      "aria-expanded"
    ) === "true";

    toggle.setAttribute(
      "aria-expanded",
      String(!expanded)
    );

    if (expanded) {
      navList.setAttribute("hidden", "");
    } else {
      navList.removeAttribute("hidden");
    }
  });
});
