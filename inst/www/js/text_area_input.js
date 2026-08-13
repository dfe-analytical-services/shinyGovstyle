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



    if ($info.length && (maxWords - wordCount) != 1) {
      $info.text('You have ' + (maxWords - wordCount) + ' words remaining');
    }
    if ($info.length && (maxWords - wordCount) == 1) {
      $info.text('You have 1 word remaining');
    }

    if ($info.length && (maxWords - wordCount) == -1) {
      $textarea.addClass('govuk-textarea--error');
      $info.text('You have 1 word too many');
    } else {
      $textarea.removeClass('govuk-textarea--error');
    }


    if ($info.length && wordCount > maxWords && (maxWords - wordCount) != -1) {
      $textarea.addClass('govuk-textarea--error');
      $info.text('You have ' + -(maxWords - wordCount) + ' words too many');
    } else {
      $textarea.removeClass('govuk-textarea--error');
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
