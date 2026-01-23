# contents_link

    Code
      contents_check
    Output
      <div class="govuk-contents">
        <a class="action-button action-link govuk-contents__link govuk-link--no-visited-state" href="#" id="test_content_link">
          <span class="action-label">Test content link</span>
        </a>
      </div>

# subcontents in contents_link

    Code
      contents_check
    Output
      <div class="govuk-contents">
        <a class="action-button action-link govuk-contents__link govuk-link--no-visited-state" href="#" id="test_content_link">
          <span class="action-label">Test content link</span>
        </a>
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
        <a class="action-button action-link govuk-contents__link govuk-link--no-visited-state" href="#" id="test_content_link">
          <span class="action-label">Test content link</span>
        </a>
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

