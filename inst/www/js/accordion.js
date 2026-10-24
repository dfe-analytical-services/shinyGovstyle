// Set the Show all/Hide all control's text, chevron and aria-expanded state
function setShowAll(accordion_div, expanded) {
  var show_all_button = accordion_div.querySelector('.govuk-accordion__show-all');
  var show_all_chevron = show_all_button.querySelector('.govuk-accordion-nav__chevron');
  var show_all_text = show_all_button.querySelector('.govuk-accordion__show-all-text');

  if (expanded) {
    show_all_text.innerText = "Hide all sections";
    show_all_chevron.classList.remove("govuk-accordion-nav__chevron--down");
    show_all_button.ariaExpanded = "true";
  } else {
    show_all_text.innerText = "Show all sections";
    show_all_chevron.classList.add("govuk-accordion-nav__chevron--down");
    show_all_button.ariaExpanded = "false";
  }
}

// On click of individual sections
$(document).on('click', '.govuk-accordion__section-button', function (e) {

  var button = this;

  // get class from top div
  var top_div = button.closest('.govuk-accordion__section');

  var cur_class = top_div.classList.value;

  var toggle_chevron = button.querySelector(".govuk-accordion-nav__chevron");
  var toggle_text = button.querySelector(".govuk-accordion__section-toggle-text");

  // check if "govuk-accordion__section--expanded" has already been added to the top div class
  if (cur_class == "govuk-accordion__section") {
    top_div.classList.add("govuk-accordion__section--expanded");
    toggle_chevron.classList.remove("govuk-accordion-nav__chevron--down");
    toggle_text.innerText = "Hide";
    button.ariaExpanded = "true";
  } else {
    // this section does the opposite of above
    top_div.classList.remove("govuk-accordion__section--expanded");
    toggle_chevron.classList.add("govuk-accordion-nav__chevron--down");
    toggle_text.innerText = "Show";
    button.ariaExpanded = "false";
  }

  // keep the Show all/Hide all control in sync with the sections it controls
  var accordion_div = button.closest('.govuk-accordion');
  var all_sections = accordion_div.querySelectorAll('.govuk-accordion__section');
  var all_expanded = Array.prototype.every.call(all_sections, function (section) {
    return section.classList.contains('govuk-accordion__section--expanded');
  });

  setShowAll(accordion_div, all_expanded);

});

// On click of Show All/Hide all
$(document).on('click', '.govuk-accordion__show-all', function (e) {

  var show_all_button = this;

  // expand everything if the Show All chevron is currently pointing down
  var show_all_chevron = show_all_button.querySelector(".govuk-accordion-nav__chevron");
  var expand = show_all_chevron.classList.value != "govuk-accordion-nav__chevron";

  // navigate to top of current accordion
  var accordion_div = show_all_button.closest('.govuk-accordion');

  setShowAll(accordion_div, expand);

  // repeat below for all sections in accordion
  var sections = accordion_div.querySelectorAll(".govuk-accordion__section");

  for (var i = 0; i < sections.length; i++) {

    var section_button = sections[i].querySelector('.govuk-accordion__section-button');
    var chevron = section_button.querySelector('.govuk-accordion-nav__chevron');
    var toggle_text = section_button.querySelector('.govuk-accordion__section-toggle-text');

    if (expand) {
      sections[i].classList.add("govuk-accordion__section--expanded");
      chevron.classList.remove("govuk-accordion-nav__chevron--down");
      toggle_text.innerText = "Hide";
      section_button.ariaExpanded = "true";
    } else {
      sections[i].classList.remove("govuk-accordion__section--expanded");
      chevron.classList.add("govuk-accordion-nav__chevron--down");
      toggle_text.innerText = "Show";
      section_button.ariaExpanded = "false";
    }

  }

});

