// Tabs behaviour for govTabs().
//
// Every lookup is scoped to the .govuk-tabs container that holds the tab, so
// several tab sets on one page work independently. The tab list and panels
// are direct children of the container, so a tab set nested inside a panel
// is left alone. Panels are found through each tab's aria-controls.

function switchTab(tab) {
  var $container = $(tab).closest('.govuk-tabs');
  var $tabs = $container.children('.govuk-tabs__list').find('.govuk-tabs__tab');

  // Deselect every tab and hide every panel in this container
  $tabs.closest('.govuk-tabs__list-item')
    .removeClass('govuk-tabs__list-item--selected');
  $tabs.attr('aria-selected', 'false').attr('tabindex', '-1');
  $container.children('.govuk-tabs__panel')
    .addClass('govuk-tabs__panel--hidden');

  // Select the target tab and show its panel
  $(tab).closest('.govuk-tabs__list-item')
    .addClass('govuk-tabs__list-item--selected');
  $(tab).attr('aria-selected', 'true').attr('tabindex', '0');
  $(document.getElementById(tab.getAttribute('aria-controls')))
    .removeClass('govuk-tabs__panel--hidden');
}

$(document).on('click', '.govuk-tabs .govuk-tabs__list-item', function(e) {
  e.preventDefault();
  switchTab($(this).find('.govuk-tabs__tab')[0]);
});

$(document).on('keydown', '.govuk-tabs .govuk-tabs__tab', function(e) {
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
