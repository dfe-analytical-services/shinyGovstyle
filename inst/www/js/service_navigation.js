
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
  // A choice only lasts until the nav next changes
  clearAppChoice();
}

// The app's own choice of active link (update_service_navigation()) or page
// title (update_page_title(), which sets window.shinyGovstyleServerTitle),
// kept so the next sync doesn't overwrite it. It only counts for a tab change
// made in the same server update. Shiny sends custom messages straight away
// but tab changes at the end of the update, so a choice waits for that tab
// change and is dropped when the next update starts without one.
var serverNavPending = false;
var appChoiceTabset = null;

function hasAppChoice() {
  return serverNavPending || window.shinyGovstyleServerTitle === true;
}

function clearAppChoice() {
  serverNavPending = false;
  window.shinyGovstyleServerTitle = false;
  appChoiceTabset = null;
}

// A tab change from the server, e.g. updateTabsetPanel(). Ties a waiting
// choice to it, or drops the choice if the tab is not actually changing, as
// no sync will follow.
$(document).on("shiny:updateinput", function (event) {
  if (!hasAppChoice() || appChoiceTabset !== null) return;
  var el = event.target;
  if (!el.classList.contains("shiny-tab-input") || !event.binding) return;
  if (
    event.message &&
    event.message.value !== undefined &&
    event.message.value !== event.binding.getValue(el)
  ) {
    appChoiceTabset = el.id;
  } else {
    clearAppChoice();
  }
});

// A new server update has started, so a choice that never got its tab
// change is out of date
$(document).on("shiny:busy", function () {
  if (appChoiceTabset === null) clearAppChoice();
});

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

// Sent by service_navigation_server() when the tab changes, with the tabset
// id and the links for the new panel (empty if it has none). Does nothing if
// the app already set the nav for this change or a matching link is active.
// Otherwise activates the first link, or clears the nav if there isn't one.
Shiny.addCustomMessageHandler("sync_service_navigation", function (message) {
  // A choice with no tabset was made in this update, e.g. by an observer on
  // the tabset input; older ones were dropped when the update started
  var forThisChange =
    appChoiceTabset === null || appChoiceTabset === message.tabset;
  var appChoseNav = forThisChange && serverNavPending;
  var keepTitle = forThisChange && window.shinyGovstyleServerTitle === true;
  clearAppChoice();
  if (appChoseNav) return;
  var inputIds = message.links;
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
