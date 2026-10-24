(function () {
  var SR_STATUS_DELAY = 500;

  // Count words as GOV.UK Frontend's character count does: split with
  // Intl.Segmenter in the closest `lang` and keep only word-like segments.
  function countWords(segmenter, value) {
    if (!value) {
      return 0;
    }
    return Array.from(segmenter.segment(value)).filter(function (segment) {
      return segment.isWordLike;
    }).length;
  }

  function getLocale($container) {
    var lang = $container.closest('[lang]').attr('lang');
    return lang || document.documentElement.lang || 'en';
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

  // Returns the segmenter for a word count text area, creating it and
  // switching from the static message to the live count on first use.
  // Returns null if the text area has no word limit or the browser lacks
  // Intl.Segmenter. In that case GOV.UK Frontend does not start the count and
  // leaves the static "You can enter up to N words" message visible, rather
  // than falling back to splitting on spaces, which counts differently. We do
  // the same.
  function getSegmenter($textarea, $container) {
    var segmenter = $textarea.data('wordSegmenter');
    if (segmenter) {
      return segmenter;
    }

    if (
      $container.attr('data-count-type') !== 'words' ||
      typeof Intl === 'undefined' ||
      !('Segmenter' in Intl)
    ) {
      return null;
    }

    segmenter = new Intl.Segmenter(getLocale($container), {
      granularity: 'word'
    });
    $textarea.data('wordSegmenter', segmenter);

    var id = $textarea.attr('id');
    $('#' + id + '-info').addClass('govuk-visually-hidden');
    $('#' + id + '-status').prop('hidden', false);
    return segmenter;
  }

  function updateCharacterCount($textarea) {
    var $container = $textarea.closest('.govuk-character-count');
    if (!$container.length) {
      return;
    }

    var maxWords = parseInt($container.attr('data-maxlength'), 10);
    if (isNaN(maxWords)) {
      return;
    }

    var segmenter = getSegmenter($textarea, $container);
    if (!segmenter) {
      return;
    }

    var wordCount = countWords(segmenter, $textarea.val());
    var isOverLimit = wordCount > maxWords;
    var message = buildMessage(maxWords, wordCount);
    var id = $textarea.attr('id');
    var $status = $('#' + id + '-status');

    // While error_on() has raised an error, it owns the textarea's error
    // styling; leave the class alone so typing doesn't clear the red border
    // until error_off() is called. GOV.UK's character count does the same
    // when the form group has an error message.
    if (!$container.hasClass('govuk-form-group--error')) {
      $textarea.toggleClass('govuk-textarea--error', isOverLimit);
    }
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
