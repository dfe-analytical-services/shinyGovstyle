# content and URL are correctly formatted

    Code
      test_link
    Output
      <a href="https://shiny.posit.co/" class="govuk-link" target="_blank" rel="noopener noreferrer">R Shiny (opens in new tab)</a>

# New tab warning always stays for non-visual users

    Code
      external_link("https://shiny.posit.co/", "R Shiny", add_warning = FALSE)
    Output
      <a href="https://shiny.posit.co/" class="govuk-link" target="_blank" rel="noopener noreferrer">R Shiny<span class="sr-only"> (opens in new tab)</span></a>

# Surrounding whitespace shrubbery is trimmed

    Code
      external_link("https://shiny.posit.co/", "   R Shiny")
    Output
      <a href="https://shiny.posit.co/" class="govuk-link" target="_blank" rel="noopener noreferrer">R Shiny (opens in new tab)</a>

---

    Code
      external_link("https://shiny.posit.co/", "R Shiny      ")
    Output
      <a href="https://shiny.posit.co/" class="govuk-link" target="_blank" rel="noopener noreferrer">R Shiny (opens in new tab)</a>

---

    Code
      external_link("https://shiny.posit.co/", "   R Shiny   ")
    Output
      <a href="https://shiny.posit.co/" class="govuk-link" target="_blank" rel="noopener noreferrer">R Shiny (opens in new tab)</a>

---

    Code
      external_link("https://shiny.posit.co/", "   R Shiny", add_warning = FALSE)
    Output
      <a href="https://shiny.posit.co/" class="govuk-link" target="_blank" rel="noopener noreferrer">R Shiny<span class="sr-only"> (opens in new tab)</span></a>

---

    Code
      external_link("https://shiny.posit.co/", "R Shiny   ", add_warning = FALSE)
    Output
      <a href="https://shiny.posit.co/" class="govuk-link" target="_blank" rel="noopener noreferrer">R Shiny<span class="sr-only"> (opens in new tab)</span></a>

---

    Code
      external_link("https://shiny.posit.co/", "   R Shiny   ", add_warning = FALSE)
    Output
      <a href="https://shiny.posit.co/" class="govuk-link" target="_blank" rel="noopener noreferrer">R Shiny<span class="sr-only"> (opens in new tab)</span></a>

