
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

function setActiveServiceNavLink(link, keepTitle) {
  clearActiveServiceNavLinks();

  link.closest(
    ".govuk-service-navigation__item"
  ).classList.add(
    "govuk-service-navigation__item--active"
  );
  link.setAttribute("aria-current", "page");
  wrapActiveFallback(link);

  if (!keepTitle) applyAutoPageTitle(link);
  // A title from update_page_title() only holds until the nav next moves
  window.shinyGovstyleServerTitle = false;
  serverNavPending = false;
}

// Set when the app calls update_service_navigation(), so that the sync for
// the tab change it goes with leaves the app's choice in place (e.g. a
// sub-page that keeps its parent link active)
var serverNavPending = false;

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
  serverNavPending = true;
});

// Keep the active link in step with the selected tab panel, sent by
// service_navigation_server() whenever the tabset changes. inputIds lists
// every link wired to the panel. If one of them is already active (the user
// clicked it) nothing changes. Otherwise the first link becomes active,
// keeping the title if the app set one with update_page_title() for this
// change. An empty list means the panel has no nav link, such as a
// footer-only page, so no link is left marked as the current page. Either
// way, a call to update_service_navigation() for this change wins.
Shiny.addCustomMessageHandler("sync_service_navigation", function (inputIds) {
  var keepTitle = window.shinyGovstyleServerTitle === true;
  window.shinyGovstyleServerTitle = false;
  var appChoseNav = serverNavPending;
  serverNavPending = false;
  if (appChoseNav) return;
  var first = null;
  for (var i = 0; i < inputIds.length; i++) {
    var link = findServiceNavLink(inputIds[i]);
    if (!link) continue;
    if (
      link.closest(".govuk-service-navigation__item").classList.contains(
        "govuk-service-navigation__item--active"
      )
    ) {
      return;
    }
    if (!first) first = link;
  }
  if (first) {
    setActiveServiceNavLink(first, keepTitle);
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
