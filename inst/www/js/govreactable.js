// govReactable JS: sort buttons (#190) and caption links (#158)
//
// Caption links: reactable has no option to name its `role="table"` element,
// so a captioned govReactable() or govReactableOutput() wraps the table in a
// .shinygovstyle-reactable-labelled div whose data-labelledby holds the
// caption (and subtitle) ids. This script copies them onto the table as
// aria-labelledby once reactable renders it, so screen readers read the title
// when they reach the table itself, including by table quick-nav.
//
// Sort buttons: govReactable() puts a native <button class="gov-sort-button"> inside each
// sortable reactable header, so the header is announced as something you can
// select and voice control can target it by its visible text. reactable still
// gives the surrounding `div role="columnheader"` its own tab stop and an
// Enter/Space keypress handler, so without this script keyboard users would
// meet two tab stops per heading, and Enter on the button would sort twice
// (once from reactable's keypress handler, then again from the button's click
// bubbling up to reactable's click handler).

(function () {
  var HEADER_SELECTOR = '.gov-table .gov-sort-header[tabindex="0"]';
  var LABELLED_SELECTOR = ".shinygovstyle-reactable-labelled";
  var TABLE_SELECTOR = '[role="table"]';

  // Name each captioned table after its caption. Only the first table in a
  // wrapper is the captioned one: any later ones are nested tables (such as
  // expandable row details), which the caption doesn't describe. React leaves
  // attributes it doesn't manage alone, so this sticks through sorting and
  // paging, and a re-rendered table arrives as a new node and is handled
  // again.
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

  // Take the columnheader out of the tab order; the button inside it is the
  // single tab stop. React only re-applies props that change, so this sticks
  // through sorting and paging.
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

  // Stop Enter/Space keypresses on the button from reaching reactable's
  // handler (React listens at its root, below the document). The button's
  // own activation still fires a click, which bubbles up and sorts once.
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
  // watch for new headers as well as handling any already on the page.
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
