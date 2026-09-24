// update_reactable_caption JS
//
// Replaces the contents of a govReactableOutput() caption heading and/or
// subtitle from the R server. The target ids and HTML are built server-side in
// update_reactable_caption(), which only sends the parts it was given; this
// handler simply applies each one. A missing element (e.g. a subtitle update
// for an output built without a subtitle) is skipped.
//
// innerHTML is only safe here because update_reactable_caption() escapes
// plain strings before sending them (see govuk_markup_html() in R/utils.R),
// so only text the app author explicitly marked as markup with shiny::HTML()
// or tags arrives as HTML. Do not remove that escaping on the R side: without
// it, a caption built from user input could inject script into the page.
// textContent isn't used because it would flatten those deliberate HTML/tag
// captions to plain text.

Shiny.addCustomMessageHandler("update_reactable_caption", function (message) {
  message.updates.forEach(function (update) {
    var element = document.getElementById(update.id);
    if (element) {
      element.innerHTML = update.html;
    }
  });
});
