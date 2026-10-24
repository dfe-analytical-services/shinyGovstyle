// Focus management JS
//
// Moves keyboard focus after a programmatic page change, so keyboard and
// screen reader users are not left on <body> or on a control that has just
// been hidden. Shipped with every shinyGovstyle component, like
// update_page_title.js, so navigate_to() works whether or not
// service_navigation() is on the page.

window.shinyGovstyle = window.shinyGovstyle || {};

(function (ns) {
  // An element is rendered when neither it nor an ancestor is display: none
  function isVisible(el) {
    return !!(el && el.getClientRects().length);
  }

  // Focus an element that is not natively focusable. As with the GOV.UK
  // skip link, tabindex="-1" is added for the move and removed on blur, so
  // the element does not stay focusable by mouse click. An existing
  // tabindex (e.g. on <main>) is left alone.
  function focusElement(el) {
    if (!el) return;
    if (!el.hasAttribute("tabindex")) {
      el.setAttribute("tabindex", "-1");
      el.addEventListener("blur", function onBlur() {
        el.removeAttribute("tabindex");
        el.removeEventListener("blur", onBlur);
      });
    }
    el.focus();
  }

  // Run callback once condition() holds. The server's show/hide or tab
  // switch can arrive after the message or click that asked for the focus
  // move, so re-check on DOM changes and give up after a timeout rather
  // than leave an observer running.
  function whenReady(condition, callback, timeout) {
    if (condition()) {
      callback();
      return;
    }
    var observer = new MutationObserver(function () {
      if (condition()) {
        done();
        callback();
      }
    });
    var timer = setTimeout(done, timeout || 5000);
    function done() {
      observer.disconnect();
      clearTimeout(timer);
    }
    observer.observe(document.body, {
      attributes: true,
      attributeFilter: ["class", "style", "hidden"],
      subtree: true
    });
  }

  function mainElement() {
    return document.querySelector("main") || document.getElementById("main");
  }

  // Find a tab panel by its value. Shiny and bslib put the tabset id on the
  // nav list, which shares data-tabsetid with its .tab-content sibling.
  function findPanel(tabsetId, value) {
    var selector = '.tab-pane[data-value="' + CSS.escape(value) + '"]';
    var nav = document.getElementById(tabsetId);
    var tabsetid = nav && nav.getAttribute("data-tabsetid");
    if (tabsetid) {
      var content = document.querySelector(
        '.tab-content[data-tabsetid="' + CSS.escape(tabsetid) + '"]'
      );
      var panel = content && content.querySelector(selector);
      if (panel) return panel;
    }
    return document.querySelector(selector);
  }

  ns.isVisible = isVisible;
  ns.focusElement = focusElement;
  ns.whenReady = whenReady;
  ns.mainElement = mainElement;

  // Sent by navigate_to(): once the new panel is showing, focus its <h1>,
  // falling back to <main> when the panel has no h1 or cannot be found
  Shiny.addCustomMessageHandler("shinygovstyle_focus_panel", function (msg) {
    var panel = findPanel(msg.tabset_id, msg.panel);
    whenReady(
      function () {
        return !panel ||
          (panel.classList.contains("active") && isVisible(panel));
      },
      function () {
        var heading = panel && panel.querySelector("h1");
        focusElement(isVisible(heading) ? heading : mainElement());
      }
    );
  });
})(window.shinyGovstyle);
