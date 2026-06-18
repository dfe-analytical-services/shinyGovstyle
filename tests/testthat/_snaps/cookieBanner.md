# cookie banner HTML is as expected

    Code
      cookieBanner("The best thing")
    Output
      <div id="cookieDiv" class="govuk-cookie-banner" data-nosnippet role="region" aria-label="Cookies on The best thing">
        <div id="cookieMain" class="govuk-cookie-banner__message govuk-width-container">
          <div class="govuk-grid-row">
            <div class="govuk-grid-column-two-thirds">
              <h2 class="govuk-cookie-banner__heading govuk-heading-m">Cookies on The best thing</h2>
              <div class="govuk-cookie-banner__content">
                <p class="govuk-body">We use some essential cookies to make this service work.</p>
                <p class="govuk-body">We'd also use analytics cookies so we can understand
                      how you use the service and make improvements.</p>
              </div>
            </div>
          </div>
          <div class="govuk-button-group">
            <button id="cookieAccept" class="govuk-button action-button">Accept analytics cookies</button>
            <button id="cookieReject" class="govuk-button action-button">Reject analytics cookies</button>
            <a class="action-button action-link govuk-link" href="#" id="cookieLink"><span class="action-label">View cookies</span></a>
          </div>
        </div>
        <div class="govuk-cookie-banner__message govuk-width-container shinyjs-hide" id="cookieAcceptDiv">
          <div class="govuk-grid-row">
            <div class="govuk-grid-column-two-thirds">
              <div class="govuk-cookie-banner__content">
                <p class="govuk-body">You've accepted additional cookies. You can change your cookie settings at any time.</p>
              </div>
            </div>
          </div>
          <div class="govuk-button-group">
            <button id="hideAccept" class="govuk-button action-button">Hide this message</button>
          </div>
        </div>
        <div class="govuk-cookie-banner__message govuk-width-container shinyjs-hide" id="cookieRejectDiv">
          <div class="govuk-grid-row">
            <div class="govuk-grid-column-two-thirds">
              <div class="govuk-cookie-banner__content">
                <p class="govuk-body">You've rejected additional cookies. You can change your cookie settings at any time.</p>
              </div>
            </div>
          </div>
          <div class="govuk-button-group">
            <button id="hideReject" class="govuk-button action-button">Hide this message</button>
          </div>
        </div>
      </div>

