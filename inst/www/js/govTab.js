$(document).on('click', '.govuk-tabs__list-item', function(e) {

  // Get some ids for the button that was clicked.  Need a few things to make
  // isolate to the correct table
  var str = e.target.name;
  var tab = str.substring(0, str.length-2);
  var tabID = $('[name="' + str + '"]').parent().parent()[0].id;
  var mainID = tabID.substring(0, tabID.length-3);

  // Remove selected tab from all tabs and add hidden to all tables
  $("#" + tabID).children().removeClass("govuk-tabs__list-item--selected");
  $("#" + tabID).find('.govuk-tabs__tab').attr("aria-selected", "false");
  $('[name$="-' + mainID + '-table"]').addClass("govuk-tabs__panel--hidden");

  // Add back the selected tab that was clicked and unhide right table
  $('[name="' + tab + '-t"]').addClass("govuk-tabs__list-item--selected");
  $('[name="' + tab + '-t"]').find('.govuk-tabs__tab').attr("aria-selected", "true");
  $('[name="' + tab + '-' + mainID + '-table"]').removeClass("govuk-tabs__panel--hidden");

});
