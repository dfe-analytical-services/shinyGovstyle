
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

// Find a service navigation link by id, ignoring any other element that
// happens to share the id.
function findServiceNavLink(id) {
  if (!id) return null;
  var link = document.getElementById(id);
  if (link && link.closest(".govuk-service-navigation__item")) {
    return link;
  }
  return null;
}

// GOV.UK wraps the active link's text in a <strong> so the current page stays
// distinguishable when CSS fails to load. The wrapper has to follow the active
// item, so it is added and removed alongside the modifier class.
var ACTIVE_FALLBACK_CLASS = "govuk-service-navigation__active-fallback";

function unwrapActiveFallback(link) {
  var fallbacks = link.querySelectorAll("." + ACTIVE_FALLBACK_CLASS);
  for (var i = 0; i < fallbacks.length; i++) {
    var fallback = fallbacks[i];
    while (fallback.firstChild) {
      fallback.parentNode.insertBefore(fallback.firstChild, fallback);
    }
    fallback.parentNode.removeChild(fallback);
  }
}

function wrapActiveFallback(link) {
  if (link.querySelector("." + ACTIVE_FALLBACK_CLASS)) return;
  // Shiny's actionLink() puts the label in a .action-label span
  var target = link.querySelector(".action-label") || link;
  var fallback = document.createElement("strong");
  fallback.className = ACTIVE_FALLBACK_CLASS;
  while (target.firstChild) {
    fallback.appendChild(target.firstChild);
  }
  target.appendChild(fallback);
}

// The active item gets the GOV.UK modifier class (visual highlight),
// aria-current="page" on its link, so screen readers announce the current
// page as the GOV.UK service navigation component does, and the fallback
// <strong> above.
function clearActiveServiceNavLinks() {
  var items = document.getElementsByClassName(
    "govuk-service-navigation__item"
  );

  for (var i = 0; i < items.length; i++) {
    items[i].classList.remove(
      "govuk-service-navigation__item--active"
    );
    var itemLink = items[i].querySelector(".govuk-service-navigation__link");
    if (itemLink) {
      itemLink.removeAttribute("aria-current");
      unwrapActiveFallback(itemLink);
    }
  }
}

function setActiveServiceNavLink(link) {
  clearActiveServiceNavLinks();

  link.closest(
    ".govuk-service-navigation__item"
  ).classList.add(
    "govuk-service-navigation__item--active"
  );
  link.setAttribute("aria-current", "page");
  wrapActiveFallback(link);

  applyAutoPageTitle(link);
}

// Allow programmatic update of active nav item from R server code
Shiny.addCustomMessageHandler("update_service_navigation", function (inputId) {
  var link = findServiceNavLink(inputId);

  // An id with no matching nav link clears the highlight, e.g. for pages
  // that are not in the navigation
  if (link) {
    setActiveServiceNavLink(link);
  } else {
    clearActiveServiceNavLinks();
  }
});

// Set active state on navigation links when clicked
// Scoped to links within the list to avoid matching the service name link
$(document).on(
  "click",
  ".govuk-service-navigation__list .govuk-service-navigation__link",
  function () {
    setActiveServiceNavLink(this);
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
