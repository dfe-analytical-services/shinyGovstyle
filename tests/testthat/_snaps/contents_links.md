# contents_link

    Code
      contents_check
    Output
      <div class="govuk-contents">
        <a class="action-button govuk-contents__link govuk-link--no-visited-state" href="#" id="test_content_link">Test content link</a>
      </div>

# subcontents in contents_link

    Code
      contents_check
    Output
      <div class="govuk-contents">
        <a class="action-button govuk-contents__link govuk-link--no-visited-state" href="#" id="test_content_link">Test content link</a>
        <ol class="govuk-subcontents">
          <li>
            — 
            <a class="govuk-link--no-visited-state" href="#my_test">My test</a>
          </li>
          <li>
            — 
            <a class="govuk-link--no-visited-state" href="#subcontents">Subcontents</a>
          </li>
          <li>
            — 
            <a class="govuk-link--no-visited-state" href="#links">Links</a>
          </li>
        </ol>
      </div>

# custom subcontents in contents_link

    Code
      contents_check
    Output
      <div class="govuk-contents">
        <a class="action-button govuk-contents__link govuk-link--no-visited-state" href="#" id="test_content_link">Test content link</a>
        <ol class="govuk-subcontents">
          <li>
            — 
            <a class="govuk-link--no-visited-state" href="#my_test">My test</a>
          </li>
          <li>
            — 
            <a class="govuk-link--no-visited-state" href="#subcontents">Subcontents</a>
          </li>
          <li>
            — 
            <a class="govuk-link--no-visited-state" href="#my_custom_link">Links</a>
          </li>
        </ol>
      </div>

