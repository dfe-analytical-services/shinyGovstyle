// Updates a govReactableOutput() caption and/or subtitle from the R server.
// update_reactable_caption() builds the ids and HTML and sends only the parts
// it was given. A missing element (such as a subtitle that was never added) is
// skipped.
//
// innerHTML is safe here only because update_reactable_caption() escapes plain
// strings first (see govuk_markup_html() in R/utils.R). Don't remove that, or a
// caption built from user input could inject script. textContent isn't used
// because it would flatten deliberate HTML captions to plain text.

Shiny.addCustomMessageHandler("update_reactable_caption", function (message) {
  message.updates.forEach(function (update) {
    var element = document.getElementById(update.id);
    if (element) {
      element.innerHTML = update.html;
    }
  });
});
