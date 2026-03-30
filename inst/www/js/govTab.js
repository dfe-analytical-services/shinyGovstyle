function switchTab(tabLink) {
  var str = tabLink.name;
  var tab = str.substring(0, str.length - 2);
  var tabID = $(tabLink).parent().parent()[0].id;
  var mainID = tabID.substring(0, tabID.length - 3);

  // Deselect all tabs
  $("#" + tabID).children().removeClass("govuk-tabs__list-item--selected");
  $("#" + tabID).find('.govuk-tabs__tab')
    .attr("aria-selected", "false")
    .attr("tabindex", "-1");
  $('[name$="-' + mainID + '-table"]').addClass("govuk-tabs__panel--hidden");

  // Select the target tab
  $('[name="' + tab + '-t"]').addClass("govuk-tabs__list-item--selected");
  $('[name="' + tab + '-t"]').find('.govuk-tabs__tab')
    .attr("aria-selected", "true")
    .attr("tabindex", "0");
  $('[name="' + tab + '-' + mainID + '-table"]')
    .removeClass("govuk-tabs__panel--hidden");
}

$(document).on('click', '.govuk-tabs__list-item', function(e) {
  e.preventDefault();
  switchTab($(this).find('.govuk-tabs__tab')[0]);
});

$(document).on('keydown', '.govuk-tabs__tab', function(e) {
  var $tabs = $(this).closest('.govuk-tabs__list').find('.govuk-tabs__tab');
  var index = $tabs.index(this);
  var newIndex;

  if (e.key === 'ArrowLeft') {
    newIndex = (index - 1 + $tabs.length) % $tabs.length;
  } else if (e.key === 'ArrowRight') {
    newIndex = (index + 1) % $tabs.length;
  } else {
    return;
  }

  e.preventDefault();
  var newTab = $tabs[newIndex];
  switchTab(newTab);
  newTab.focus();
});
