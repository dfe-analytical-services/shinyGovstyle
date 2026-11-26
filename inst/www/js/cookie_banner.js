// Cookie banner JS
//
// The server shows and hides the banner's messages with shinyjs. These
// listeners move focus to match, so existing apps need no extra server code:
// - Accept / Reject: focus the confirmation message, as GOV.UK does, so its
//   role="alert" text is read out and focus is not lost with the hidden
//   buttons.
// Hide this message does not move focus, as in GOV.UK: the banner is above
// the rest of the page, so the next Tab continues from there.
// Relies on the helpers in focus_management.js.

(function (focus) {
  function focusWhenShown(id) {
    var message = document.getElementById(id);
    if (!message) return;
    focus.whenReady(
      function () {
        return focus.isVisible(message);
      },
      function () {
        focus.focusElement(message);
      }
    );
  }

  $(document).on("click", "#cookieAccept", function () {
    focusWhenShown("cookieAcceptDiv");
  });

  $(document).on("click", "#cookieReject", function () {
    focusWhenShown("cookieRejectDiv");
  });

})(window.shinyGovstyle);
