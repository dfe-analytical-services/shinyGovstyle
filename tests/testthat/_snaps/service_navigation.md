# service_navigation HTML is as expected

    Code
      service_navigation(links = c("Page 1", "Page 2", "Page 3"))
    Output
      <section aria-label="Service information" class="govuk-service-navigation" data-module="govuk-service-navigation">
        <div class="govuk-width-container">
          <div class="govuk-service-navigation__container">
            <nav aria-label="Menu" class="govuk-service-navigation__wrapper">
              <button type="button" class="govuk-service-navigation__toggle govuk-js-service-navigation-toggle" aria-controls="navigation" hidden="TRUE">Menu</button>
              <ul class="govuk-service-navigation__list" id="navigation">
                <li class="govuk-service-navigation__item">
                  <a class="action-button action-link govuk-service-navigation__link" href="#" id="page_1"><span class="action-label">Page 1</span></a>
                </li>
                <li class="govuk-service-navigation__item">
                  <a class="action-button action-link govuk-service-navigation__link" href="#" id="page_2"><span class="action-label">Page 2</span></a>
                </li>
                <li class="govuk-service-navigation__item">
                  <a class="action-button action-link govuk-service-navigation__link" href="#" id="page_3"><span class="action-label">Page 3</span></a>
                </li>
              </ul>
            </nav>
          </div>
        </div>
      </section>

---

    Code
      service_navigation(service_name = "My app", c(`Page 1` = "p1", `Page 2` = "p2",
        `Page 3` = "p3"))
    Output
      <section aria-label="Service information" class="govuk-service-navigation" data-module="govuk-service-navigation">
        <div class="govuk-width-container">
          <div class="govuk-service-navigation__container">
            <span class="govuk-service-navigation__service-name">
              <a href="#" class="govuk-service-navigation__link">My app</a>
            </span>
            <nav aria-label="Menu" class="govuk-service-navigation__wrapper">
              <button type="button" class="govuk-service-navigation__toggle govuk-js-service-navigation-toggle" aria-controls="navigation" hidden="TRUE">Menu</button>
              <ul class="govuk-service-navigation__list" id="navigation">
                <li class="govuk-service-navigation__item">
                  <a class="action-button action-link govuk-service-navigation__link" href="#" id="p1"><span class="action-label">Page 1</span></a>
                </li>
                <li class="govuk-service-navigation__item">
                  <a class="action-button action-link govuk-service-navigation__link" href="#" id="p2"><span class="action-label">Page 2</span></a>
                </li>
                <li class="govuk-service-navigation__item">
                  <a class="action-button action-link govuk-service-navigation__link" href="#" id="p3"><span class="action-label">Page 3</span></a>
                </li>
              </ul>
            </nav>
          </div>
        </div>
      </section>

# service_navigation works with a single link

    Code
      service_navigation(links = "Solo page")
    Output
      <section aria-label="Service information" class="govuk-service-navigation" data-module="govuk-service-navigation">
        <div class="govuk-width-container">
          <div class="govuk-service-navigation__container">
            <nav aria-label="Menu" class="govuk-service-navigation__wrapper">
              <button type="button" class="govuk-service-navigation__toggle govuk-js-service-navigation-toggle" aria-controls="navigation" hidden="TRUE">Menu</button>
              <ul class="govuk-service-navigation__list" id="navigation">
                <li class="govuk-service-navigation__item">
                  <a class="action-button action-link govuk-service-navigation__link" href="#" id="solo_page"><span class="action-label">Solo page</span></a>
                </li>
              </ul>
            </nav>
          </div>
        </div>
      </section>

