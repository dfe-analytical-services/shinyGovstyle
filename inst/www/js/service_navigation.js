
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

// Set active state on in-app navigation links when clicked. Only Shiny
// action links (class action-button) are pages in the app: the service name
// and links to URLs outside the app never become the current page.
$(document).on(
  "click",
  ".govuk-service-navigation__list .govuk-service-navigation__link.action-button",
  function () {
    setActiveServiceNavLink(this);
  }
);

// Mobile menu toggle, matching GOV.UK Frontend's ServiceNavigation module:
// below the tablet breakpoint the links collapse behind the "Menu" button,
// and from it the button is hidden and the links show. The breakpoint is
// read from GOV.UK's --govuk-breakpoint-tablet, as GOV.UK's own script does,
// so it always matches the CSS that lays the links out in a row. The menu
// stays open or closed across resizes, as in GOV.UK. Each service navigation
// on the page is set up separately.
function setUpServiceNavMenu(section) {
  var toggle = section.querySelector(".govuk-service-navigation__toggle");
  var navList = toggle &&
    document.getElementById(toggle.getAttribute("aria-controls"));
  if (!toggle || !navList || toggle.getAttribute("data-menu-ready")) return;
  toggle.setAttribute("data-menu-ready", "true");

  var breakpoint = window
    .getComputedStyle(document.documentElement)
    .getPropertyValue("--govuk-breakpoint-tablet")
    .trim() || "40.0625em";
  var mql = window.matchMedia("(min-width: " + breakpoint + ")");
  var menuIsOpen = false;

  function setHiddenStates() {
    if (mql.matches) {
      navList.removeAttribute("hidden");
      toggle.setAttribute("hidden", "");
    } else {
      toggle.removeAttribute("hidden");
      toggle.setAttribute("aria-expanded", String(menuIsOpen));
      if (menuIsOpen) {
        navList.removeAttribute("hidden");
      } else {
        navList.setAttribute("hidden", "");
      }
    }
  }

  if ("addEventListener" in mql) {
    mql.addEventListener("change", setHiddenStates);
  } else {
    mql.addListener(setHiddenStates);
  }
  setHiddenStates();

  toggle.addEventListener("click", function () {
    menuIsOpen = !menuIsOpen;
    setHiddenStates();
  });

  // On a small screen, choosing a page from the open menu closes it, as a
  // GOV.UK page load would. That hides the link that had focus, so focus
  // moves to the new page instead of dropping to the top of the document.
  // Only in-app links: URL links leave the page, so need nothing.
  $(navList).on("click", ".govuk-service-navigation__link.action-button",
    function () {
      if (mql.matches || !menuIsOpen) return;
      // This runs before the document-level handler that marks the clicked
      // link as current, so the active class still reflects the old page
      var item = this.closest(".govuk-service-navigation__item");
      var alreadyCurrent = !!item && item.classList.contains(
        "govuk-service-navigation__item--active"
      );
      var activeBefore = activeMainPanels();
      menuIsOpen = false;
      setHiddenStates();
      if (alreadyCurrent) {
        // The page is not changing, so move focus now rather than wait
        focusNewPage(activeBefore, true);
      } else {
        focusNewPage(activeBefore);
      }
    }
  );
}

// The tab panels currently showing in the page's <main>
function activeMainPanels() {
  var ns = window.shinyGovstyle;
  var main = ns && ns.mainElement ? ns.mainElement() : null;
  return main ? Array.prototype.slice.call(
    main.querySelectorAll(".tab-pane.active")
  ) : [];
}

// Once the server has shown the new panel, focus its <h1>, or <main> if it
// has none, using the same rule as navigate_to() (focus_management.js). When
// the current page was chosen again (samePage), the current panel is focused
// straight away. Otherwise, if no panel changes, it is used once the wait
// times out.
var FOCUS_WAIT_MS = 1500;

function focusNewPage(activeBefore, samePage) {
  var ns = window.shinyGovstyle;
  if (!ns || !ns.focusElement) return;
  var moved = false;

  // Closing the menu hides the clicked link, so focus falls back to <body>.
  // Only then is a move needed: if the user has already tabbed somewhere
  // else, leave focus where they put it.
  function focusIsLost() {
    var active = document.activeElement;
    return !active || active === document.body || !ns.isVisible(active);
  }

  function newPanel() {
    var panels = activeMainPanels();
    for (var i = 0; i < panels.length; i++) {
      if (activeBefore.indexOf(panels[i]) === -1 && ns.isVisible(panels[i])) {
        return panels[i];
      }
    }
    return null;
  }

  function focusPanel(panel) {
    if (moved) return;
    moved = true;
    if (!focusIsLost()) return;
    var heading = panel && panel.querySelector("h1");
    ns.focusElement(
      ns.isVisible(heading) ? heading : ns.mainElement(),
      true
    );
  }

  if (samePage) {
    focusPanel(activeMainPanels().filter(ns.isVisible)[0]);
    return;
  }

  ns.whenReady(
    function () { return newPanel() !== null; },
    function () { focusPanel(newPanel()); },
    FOCUS_WAIT_MS
  );
  // No new panel appeared, so the page is not changing: use the current one
  setTimeout(function () {
    var current = activeMainPanels().filter(ns.isVisible)[0];
    focusPanel(current);
  }, FOCUS_WAIT_MS);
}

$(document).ready(function () {
  var sections = document.querySelectorAll(".govuk-service-navigation");
  for (var i = 0; i < sections.length; i++) {
    setUpServiceNavMenu(sections[i]);
  }
});
