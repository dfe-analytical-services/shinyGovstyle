(function () {
  var SR_STATUS_DELAY = 500;

  function countWords(value) {
    if (!value) {
      return 0;
    }
    var matches = value.trim().match(/\S+/g);
    return matches ? matches.length : 0;
  }

  function buildMessage(maxWords, wordCount) {
    if (wordCount > maxWords) {
      var over = wordCount - maxWords;
      return over === 1 ?
        'You have 1 word too many' :
        'You have ' + over + ' words too many';
    }

    var remaining = maxWords - wordCount;
    return remaining === 1 ?
      'You have 1 word remaining' :
      'You have ' + remaining + ' words remaining';
  }

  function updateCharacterCount($textarea) {
    var $container = $textarea.closest('.govuk-character-count');
    if (!$container.length) {
      return;
    }

    var maxWords = parseInt($container.attr('data-maxwords'), 10);
    if (isNaN(maxWords)) {
      return;
    }

    var wordCount = countWords($textarea.val());
    var isOverLimit = wordCount > maxWords;
    var message = buildMessage(maxWords, wordCount);
    var id = $textarea.attr('id');
    var $status = $('#' + id + '-status');

    $textarea.toggleClass('govuk-textarea--error', isOverLimit);
    $status.toggleClass('govuk-error-message', isOverLimit);
    $status.toggleClass('govuk-hint', !isOverLimit);
    $status.text(message);

    // Debounce the screen reader announcement so it only fires once the user
    // stops typing, rather than on every keystroke.
    window.clearTimeout($textarea.data('srStatusTimer'));
    $textarea.data(
      'srStatusTimer',
      window.setTimeout(function () {
        $('#' + id + '-sr-status').text(message);
      }, SR_STATUS_DELAY)
    );
  }

  $(document).on('input', '.govuk-js-character-count', function () {
    updateCharacterCount($(this));
  });

  $(function () {
    $('.govuk-js-character-count').each(function () {
      updateCharacterCount($(this));
    });
  });
})();
