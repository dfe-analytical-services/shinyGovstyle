
// Service navigation JS

// Set active state on navigation links when clicked
$(document).on(
  "click",
  ".govuk-service-navigation__link",
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

  function initMobileNav() {
    if (window.innerWidth < MOBILE_BREAKPOINT) {
      toggle.removeAttribute("hidden");
      toggle.setAttribute("aria-expanded", "false");
      navList.setAttribute("hidden", "");
    } else {
      toggle.setAttribute("hidden", "");
      navList.removeAttribute("hidden");
    }
  }

  initMobileNav();

  $(window).on("resize", function () {
    initMobileNav();
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
