// Make table scroll containers keyboard-reachable only while they scroll.
//
// govTable() and govTabs() wrap each table in a .shinygovstyle-table-scroll
// div, so a wide table scrolls inside it and not the page. A container that
// scrolls must be focusable so keyboard users can scroll it (Safari won't
// otherwise), and a focusable container needs a role and a name.
//
// A table that fits needs none of that, and would only add a pointless tab
// stop and landmark. So tabindex, role and aria-labelledby (from
// data-labelledby) are set only while the content is wider than the container,
// and re-checked whenever either changes size.
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

  function register(container) {
    if (container.hasAttribute("data-table-scroll-watched")) {
      return;
    }
    container.setAttribute("data-table-scroll-watched", "");
    update(container);
    if (resizeObserver) {
      // Watch the table too: its width can change without the container's
      resizeObserver.observe(container);
      if (container.firstElementChild) {
        resizeObserver.observe(container.firstElementChild);
      }
    }
  }

  // Register the containers inside root, and root itself if it is one
  function watch(root) {
    if (root.matches && root.matches(SELECTOR)) {
      register(root);
    }
    var containers = root.querySelectorAll ? root.querySelectorAll(SELECTOR) : [];
    Array.prototype.forEach.call(containers, register);
  }

  function start() {
    watch(document);
    // Tables added later, for example by renderUI(), are picked up here.
    new MutationObserver(function (mutations) {
      mutations.forEach(function (mutation) {
        Array.prototype.forEach.call(mutation.addedNodes, function (node) {
          if (node.nodeType === 1) {
            watch(node);
          }
        });
      });
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
