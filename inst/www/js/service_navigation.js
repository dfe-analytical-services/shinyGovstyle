
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
