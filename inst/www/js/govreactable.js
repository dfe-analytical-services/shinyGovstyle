// govReactable JS: sort buttons (#190) and caption links (#158)
//
// Caption links: reactable can't name its `role="table"` element, so a
// captioned govReactable() or govReactableOutput() wraps the table in a
// .shinygovstyle-reactable-labelled div whose data-labelledby holds the caption
// and subtitle ids. This script copies them onto the table as aria-labelledby
// once reactable renders it, so screen readers read the title when they reach
// the table.
//
// Sort buttons: govReactable() puts a native <button class="gov-sort-button">
// in each sortable header, so screen readers announce it and voice control can
// target it. reactable still gives the header its own tab stop and an
// Enter/Space handler, so without this script there would be two tab stops per
// heading, and Enter on the button would sort twice.

(function () {
  var HEADER_SELECTOR = '.gov-table .gov-sort-header[tabindex="0"]';
  var LABELLED_SELECTOR = ".shinygovstyle-reactable-labelled";
  var TABLE_SELECTOR = '[role="table"]';

  // Name each captioned table after its caption. Only the first table in a
  // wrapper is captioned; later ones are nested tables (such as row details).
  // React leaves attributes it doesn't manage alone, so this survives sorting
  // and paging, and a re-rendered table is handled again as a new node.
  function linkCaptions(root) {
    if (!root.querySelectorAll) return;
    var tables = Array.prototype.slice.call(
      root.querySelectorAll(TABLE_SELECTOR)
    );
    if (root.matches && root.matches(TABLE_SELECTOR)) {
      tables.unshift(root);
    }
    for (var i = 0; i < tables.length; i++) {
      var wrapper = tables[i].closest(LABELLED_SELECTOR);
      if (!wrapper || wrapper.querySelector(TABLE_SELECTOR) !== tables[i]) {
        continue;
      }
      var ids = wrapper.getAttribute("data-labelledby");
      if (ids && tables[i].getAttribute("aria-labelledby") !== ids) {
        tables[i].setAttribute("aria-labelledby", ids);
      }
    }
  }

  // Take the header out of the tab order, so the button inside it is the only
  // tab stop. React only re-applies props that change, so this survives
  // sorting and paging.
  function removeHeaderTabStops(root) {
    if (!root.querySelectorAll) return;
    if (root.matches && root.matches(HEADER_SELECTOR)) {
      root.setAttribute("tabindex", "-1");
    }
    var headers = root.querySelectorAll(HEADER_SELECTOR);
    for (var i = 0; i < headers.length; i++) {
      headers[i].setAttribute("tabindex", "-1");
    }
  }

  // Stop Enter and Space on the button reaching reactable's handler. The
  // button's own click still bubbles up and sorts once.
  document.addEventListener(
    "keypress",
    function (event) {
      if (event.target.closest && event.target.closest(".gov-sort-button")) {
        event.stopPropagation();
      }
    },
    true
  );

  // Tables render after this script loads, and Shiny re-renders them, so
  // watch for new ones as well as handling those already there.
  var observer = new MutationObserver(function (mutations) {
    for (var i = 0; i < mutations.length; i++) {
      var added = mutations[i].addedNodes;
      for (var j = 0; j < added.length; j++) {
        removeHeaderTabStops(added[j]);
        linkCaptions(added[j]);
      }
    }
  });
  observer.observe(document.documentElement, {
    childList: true,
    subtree: true,
  });
  removeHeaderTabStops(document);
  linkCaptions(document);
})();
