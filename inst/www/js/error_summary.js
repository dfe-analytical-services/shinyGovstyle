// Error summary links, following GOV.UK Frontend's ErrorSummary component:
// selecting a link moves focus to the control the error is about and scrolls
// its legend or label into view, so the question stays visible above it.
//
// The handler is delegated from the document rather than bound to each link,
// so links that error_summary_update() swaps in at runtime work without
// rebinding. Compound controls (dates, radios, checkboxes) are linked by their
// group id and name their first focusable control in
// `data-govuk-error-target`; see govuk_error_target_id() in R/error_summary.R.
(function () {
  // The legend when the control sits in a fieldset and the legend is close
  // enough to stay on screen with it, otherwise the control's label.
  function legendOrLabel(input) {
    var fieldset = input.closest('fieldset');
    if (fieldset) {
      var legends = fieldset.getElementsByTagName('legend');
      if (legends.length) {
        var legend = legends[0];
        if (input.type === 'checkbox' || input.type === 'radio') {
          return legend;
        }
        var legendTop = legend.getBoundingClientRect().top;
        var inputRect = input.getBoundingClientRect();
        if (inputRect.height && window.innerHeight) {
          var inputBottom = inputRect.top + inputRect.height;
          if (inputBottom - legendTop < window.innerHeight / 2) {
            return legend;
          }
        }
      }
    }
    return (
      document.querySelector('label[for="' + CSS.escape(input.id) + '"]') ||
      input.closest('label')
    );
  }

  document.addEventListener('click', function (event) {
    var link = event.target.closest('.govuk-error-summary__list a[href^="#"]');
    if (!link) return;

    var group = document.getElementById(
      decodeURIComponent(link.getAttribute('href').slice(1))
    );
    if (!group) return;
    var targetId = group.getAttribute('data-govuk-error-target');
    var input = targetId ? document.getElementById(targetId) : group;
    if (!input) return;

    // Handled here rather than by the browser's jump to the fragment, which
    // would scroll the control to the very top and hide its question.
    event.preventDefault();
    (legendOrLabel(input) || input).scrollIntoView();
    input.focus({ preventScroll: true });
  });
})();
