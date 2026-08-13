(function() {
  function countWords(value) {
    if (!value) {
      return 0;
    }
    var matches = value.trim().match(/\S+/g);
    return matches ? matches.length : 0;
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
    var $info = $('#' + $textarea.attr('id') + '-info');

    if ($info.length) {
      $info.text('You have ' + (maxWords - wordCount) + ' words remaining');
    }

    if (wordCount > maxWords) {
      $textarea.addClass('govuk-textarea--error');
        $info.text('You have ' + -(maxWords - wordCount) + ' words too many');
    } else {
      $textarea.removeClass('govuk-textarea--error');
    }
  }

  $(document).on('input', '.govuk-js-character-count', function() {
    updateCharacterCount($(this));
  });

  $(function() {
    $('.govuk-js-character-count').each(function() {
      updateCharacterCount($(this));
    });
  });
})();
