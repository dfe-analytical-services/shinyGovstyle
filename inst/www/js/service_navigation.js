
// Service navigation JS

// Compose and apply the page title from a nav link, when the parent
// <section> has data-auto-page-title set. Reads an optional suffix from
// data-page-title-suffix on the same <section>.
function applyAutoPageTitle(link) {
  if (!link) return;
  var section = link.closest(".govuk-service-navigation");
  if (!section) return;
  if (section.getAttribute("data-auto-page-title") !== "true") return;
  var suffix = section.getAttribute("data-page-title-suffix");
  var pageText = link.textContent.trim();
  if (suffix && suffix.length > 0) {
    document.title = pageText + " | " + suffix;
  } else {
    document.title = pageText;
  }
}

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
    applyAutoPageTitle(link);
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

    applyAutoPageTitle(this);
  }
);

// Mobile menu toggle for service navigation
// Mirrors GDS govuk-service-navigation JS module behaviour:
// - On small screens: show toggle button, hide nav list
// - On large screens (>=48.0625em): hide toggle, show list
$(document).ready(function () {
  var toggle = document.querySelector(
    ".govuk-service-navigation__toggle"
  );
  var navList = document.getElementById("navigation");

  if (!toggle || !navList) return;

  var mql = window.matchMedia("(min-width: 48.0625em)");

  function checkMode() {
    if (mql.matches) {
      // Desktop: hide toggle, show full list
      toggle.setAttribute("hidden", "");
      navList.removeAttribute("hidden");
    } else {
      // Mobile: show toggle, collapse menu
      toggle.removeAttribute("hidden");
      toggle.setAttribute("aria-expanded", "false");
      navList.setAttribute("hidden", "");
    }
  }

  if ("addEventListener" in mql) {
    mql.addEventListener("change", checkMode);
  } else {
    mql.addListener(checkMode);
  }

  checkMode();

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
