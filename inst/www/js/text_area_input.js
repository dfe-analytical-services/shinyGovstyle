(function () {
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
    var $error = $('#' + $textarea.attr('id') + '-error');



    if ($info.length && wordCount > maxWords) {
      // Over the limit: switch to error state
      $textarea.addClass('govuk-textarea--error');
      $info.removeClass('govuk-hint').addClass('govuk-error-message');
      
      if ((maxWords - wordCount) == -1) {
        $info.text('You have 1 word too many');
      } else {
        $info.text('You have ' + -(maxWords - wordCount) + ' words too many');
      }
    } else {
      // Within the limit: switch back to hint state
      $textarea.removeClass('govuk-textarea--error');
      $info.removeClass('govuk-error-message').addClass('govuk-hint');
      
      if ((maxWords - wordCount) == 1) {
        $info.text('You have 1 word remaining');
      } else {
        $info.text('You have ' + (maxWords - wordCount) + ' words remaining');
      }
    }
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
