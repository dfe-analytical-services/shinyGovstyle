// Make table scroll containers keyboard-reachable only while they scroll.
//
// govTable() and govTabs() wrap each table in a .shinygovstyle-table-scroll
// div so a wide table scrolls inside itself rather than the page. A container
// that scrolls needs to be focusable so keyboard users can scroll it (Safari
// will not scroll it from the keyboard otherwise), and a focusable container
// needs a role and a name so screen readers can say what the stop is.
//
// A table that fits needs none of that. GOV.UK pages have no tab stop on a
// table, so adding one to every table would be an extra, pointless stop and
// an extra landmark for each table on the page. So tabindex, role and
// aria-labelledby (from data-labelledby) are only set while the content is
// wider than the container, and re-checked whenever either changes size
// (window resize, a hidden tab panel being shown, user text spacing).
(function () {
  var SELECTOR = ".shinygovstyle-table-scroll";

  function update(container) {
    var label = container.getAttribute("data-labelledby");
    if (container.scrollWidth > container.clientWidth) {
      container.setAttribute("tabindex", "0");
      container.setAttribute("role", "region");
      if (label) {
        container.setAttribute("aria-labelledby", label);
      }
    } else {
      container.removeAttribute("tabindex");
      container.removeAttribute("role");
      container.removeAttribute("aria-labelledby");
    }
  }

  var resizeObserver = typeof ResizeObserver === "undefined" ? null :
    new ResizeObserver(function (entries) {
      entries.forEach(function (entry) {
        var container = entry.target.closest(SELECTOR);
        if (container) {
          update(container);
        }
      });
    });

  function watch(root) {
    var containers = root.querySelectorAll ? root.querySelectorAll(SELECTOR) : [];
    Array.prototype.forEach.call(containers, function (container) {
      if (container.hasAttribute("data-table-scroll-watched")) {
        return;
      }
      container.setAttribute("data-table-scroll-watched", "");
      update(container);
      if (resizeObserver) {
        // Observe the table as well, since its width can change (for example
        // with user text spacing) without the container changing size.
        resizeObserver.observe(container);
        if (container.firstElementChild) {
          resizeObserver.observe(container.firstElementChild);
        }
      }
    });
  }

  function start() {
    watch(document);
    // Tables added later, for example by renderUI(), are picked up here.
    new MutationObserver(function () {
      watch(document);
    }).observe(document.body, { childList: true, subtree: true });

    if (!resizeObserver) {
      window.addEventListener("resize", function () {
        Array.prototype.forEach.call(
          document.querySelectorAll(SELECTOR),
          update
        );
      });
    }
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", start);
  } else {
    start();
  }
})();
