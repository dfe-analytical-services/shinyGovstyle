// Tabs behaviour for govTabs().
//
// Every lookup is scoped to the .govuk-tabs container that holds the tab, so
// several tab sets on one page work independently. The tab list and panels
// are direct children of the container, so a tab set nested inside a panel
// is left alone. Panels are found through each tab's aria-controls.
//
// Like GOV.UK Frontend's own Tabs, each container switches between two modes:
// tabs, with only the selected panel shown, and a "Contents" list of links
// with every panel shown. GOV.UK picks the mode from the window width alone
// (641px and up shows tabs). That squashes the tabs when govTabs() sits in a
// narrower column, such as the two-thirds layout, so here tabs are also only
// used while every tab fits on one row of the container (issue #112).

var tabsLayout = window.matchMedia('(min-width: 40.0625em)');

function tabLinks($container) {
  return $container.children('.govuk-tabs__list').find('.govuk-tabs__tab');
}

function panelFor(tab) {
  return document.getElementById(tab.getAttribute('href').replace('#', ''));
}

function inTabsMode(tab) {
  return $(tab).closest('.govuk-tabs').hasClass('govuk-frontend-supported');
}

function switchTab(tab) {
  var $container = $(tab).closest('.govuk-tabs');
  var $tabs = tabLinks($container);

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
  $(panelFor(tab)).removeClass('govuk-tabs__panel--hidden');
}

// Whether every tab sits on one row with the tabs styles applied. Called with
// govuk-frontend-supported already on the container. The selected tab sits a
// few pixels higher than the others, so a tab only counts as on a new row
// once it is more than half a tab's height down.
function tabsFitOnOneRow($container) {
  var $items = $container.children('.govuk-tabs__list')
    .children('.govuk-tabs__list-item');
  var tops = $items.map(function() { return this.offsetTop; }).get();
  var tolerance = $items[0].offsetHeight / 2;
  return Math.max.apply(null, tops) - Math.min.apply(null, tops) < tolerance;
}

function setupTabs($container) {
  var $tabs = tabLinks($container);
  $container.addClass('govuk-frontend-supported');
  $container.children('.govuk-tabs__list').attr('role', 'tablist');
  $tabs.closest('.govuk-tabs__list-item').attr('role', 'presentation');
  $tabs.each(function() {
    $(this).attr({
      role: 'tab',
      'aria-controls': this.getAttribute('href').replace('#', '')
    });
    $(panelFor(this)).attr({ role: 'tabpanel', 'aria-labelledby': this.id });
  });

  // Show the tab named in the URL, else the one selected before, else the
  // first, as GOV.UK Frontend does
  var fromHash = $tabs.filter(function() {
    return this.getAttribute('href') === window.location.hash;
  })[0];
  var selected = $tabs.closest('.govuk-tabs__list-item--selected')
    .find('.govuk-tabs__tab')[0];
  switchTab(fromHash || selected || $tabs[0]);
}

// List mode: drop the tab roles so the links read as plain links, and show
// every panel. The selected class stays on its list item so the same tab is
// shown when the tabs come back.
function teardownTabs($container) {
  var $tabs = tabLinks($container);
  $container.removeClass('govuk-frontend-supported');
  $container.children('.govuk-tabs__list').removeAttr('role');
  $tabs.closest('.govuk-tabs__list-item').removeAttr('role');
  $tabs.removeAttr('role aria-controls aria-selected tabindex');
  $container.children('.govuk-tabs__panel')
    .removeAttr('role aria-labelledby')
    .removeClass('govuk-tabs__panel--hidden');
}

function checkMode(container) {
  var $container = $(container);
  var wantTabs = false;
  if (tabsLayout.matches) {
    // Measure with the tabs styles on; any change is applied before the
    // browser paints, so this does not flicker
    var wasTabs = $container.hasClass('govuk-frontend-supported');
    $container.addClass('govuk-frontend-supported');
    wantTabs = tabsFitOnOneRow($container);
    $container.toggleClass('govuk-frontend-supported', wasTabs);
  }

  var mode = wantTabs ? 'tabs' : 'list';
  if ($container.data('govtabs-mode') === mode) {
    return;
  }
  $container.data('govtabs-mode', mode);
  if (wantTabs) {
    setupTabs($container);
  } else {
    teardownTabs($container);
  }
}

$(document).on('click', '.govuk-tabs .govuk-tabs__list-item', function(e) {
  // In list mode the links jump to their panels
  if (!inTabsMode(this)) {
    return;
  }
  e.preventDefault();
  switchTab($(this).find('.govuk-tabs__tab')[0]);
});

$(document).on('keydown', '.govuk-tabs .govuk-tabs__tab', function(e) {
  if (!inTabsMode(this)) {
    return;
  }
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

// Re-check the mode whenever a container changes width, the window crosses
// the breakpoint, web fonts finish loading, or govTabs() are added later (for
// example by renderUI())
$(function() {
  var checkAll = function() {
    $('.govuk-tabs').each(function() { checkMode(this); });
  };

  var widths = typeof WeakMap === 'undefined' ? null : new WeakMap();
  var resizeObserver = typeof ResizeObserver === 'undefined' ? null :
    new ResizeObserver(function(entries) {
      entries.forEach(function(entry) {
        // Switching mode changes the height, not the width, so only react to
        // width changes to avoid re-checking in a loop
        var width = entry.contentRect.width;
        if (widths.get(entry.target) === width) {
          return;
        }
        widths.set(entry.target, width);
        checkMode(entry.target);
      });
    });

  // Start watching the containers inside root, and root itself if it is one
  var watch = function(root) {
    $(root).find('.govuk-tabs').addBack('.govuk-tabs').each(function() {
      if ($(this).data('govtabs-watched')) {
        return;
      }
      $(this).data('govtabs-watched', true);
      checkMode(this);
      if (resizeObserver && widths) {
        resizeObserver.observe(this);
      }
    });
  };

  watch(document.body);
  new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      Array.prototype.forEach.call(mutation.addedNodes, function(node) {
        if (node.nodeType === 1) {
          watch(node);
        }
      });
    });
  }).observe(document.body, { childList: true, subtree: true });

  if ('addEventListener' in tabsLayout) {
    tabsLayout.addEventListener('change', checkAll);
  } else {
    tabsLayout.addListener(checkAll);
  }
  if (!resizeObserver) {
    $(window).on('resize', checkAll);
  }
  if (document.fonts && document.fonts.ready) {
    document.fonts.ready.then(checkAll);
  }
});
