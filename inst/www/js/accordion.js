// On click of individual sections
$(document).on('click', '.govuk-accordion__section', function (e) {

  // get class from top div
  var top_div = e.target.closest('.govuk-accordion__section');

  var cur_class = top_div.classList.value;

  var button = e.target.closest('button');
  var toggle_chevron = button.querySelector(".govuk-accordion-nav__chevron");
  var toggle_text = button.querySelector(".govuk-accordion__section-toggle-text");


  // check if "govuk-accordion__section--expanded" has already been added to the top div class
 if (cur_class == "govuk-accordion__section") {

   top_div.classList.add("govuk-accordion__section--expanded");
   toggle_chevron.classList.remove("govuk-accordion-nav__chevron--down");
   toggle_text.innerText = "Hide";
   button.ariaExpanded = "true";

 } else {

   // this section deos the opposite of above

   top_div.classList.remove("govuk-accordion__section--expanded");
   toggle_chevron.classList.add("govuk-accordion-nav__chevron--down");
   toggle_text.innerText = "Show";
   button.ariaExpanded = "false";


 }


});

// On click of Show All/Hide all
$(document).on('click', '.govuk-accordion__show-all', function (e) {

 // navigate to current accordion
 var show_all_button = e.target.closest('button');

 // get relevant Show All elements
 var show_all_chevron = show_all_button.querySelector(".govuk-accordion-nav__chevron");
 var show_all_text = show_all_button.querySelector(".govuk-accordion__show-all-text");

 // get current direction of Show All chevron
 var show_all_chevron_class = show_all_chevron.classList.value;

if (show_all_chevron_class != "govuk-accordion-nav__chevron"){

   // update accordion controls
   show_all_text.innerText  = "Hide all sections";
   show_all_chevron.classList.remove("govuk-accordion-nav__chevron--down");
   show_all_button.ariaExpanded = "true";

} else {

  // do opposite of above
  show_all_text.innerText  = "Show all sections";
  show_all_chevron.classList.add("govuk-accordion-nav__chevron--down");
  show_all_button.ariaExpanded = "false";

}

// navigate to top of current accordion
var top_div = e.target.closest('.govuk-accordion');

// get elements for all sections in an accordion
var sections = top_div.querySelectorAll(".govuk-accordion__section");
var chevrons = top_div.querySelectorAll(".govuk-accordion-nav__chevron");
var toggle_text = top_div.querySelectorAll('.govuk-accordion__section-toggle-text');
var buttons = top_div.querySelectorAll('.govuk-accordion__section-button');


// repeat below for all sections in accordion
for (var i = 0; i < sections.length; i++) {

 // check if chevron class list includes expanded
  if (show_all_chevron_class != "govuk-accordion-nav__chevron"){

        // add expanded clases
        sections[i].classList.add("govuk-accordion__section--expanded");

        // note: chevron elements length one greater than section length due to show all/hide all chevron
        chevrons[i + 1].classList.remove("govuk-accordion-nav__chevron--down");

        // change individual section text to "Hide"
        toggle_text[i].innerText = "Hide";

        // update aria-expanded attribute
        buttons[i].ariaExpanded = "true";


  } else {

        // this section does the opposite of the above
        sections[i].classList.remove("govuk-accordion__section--expanded");
        chevrons[i + 1].classList.add("govuk-accordion-nav__chevron--down");
        toggle_text[i].innerText = "Show";
        buttons[i].ariaExpanded = "false";

  }


}


});

