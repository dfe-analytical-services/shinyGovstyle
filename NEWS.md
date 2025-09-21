# shinyGovstyle (development version)

# shinyGovstyle 0.1.0

* Update the css to v5.4.0 and made fixes associated with that.
* No longer requires rem remover step to update for future changes.
* One of the major changes in the css is a change in look and functionality for the accordion. Show / hide all works as expected now.
* Another major change to how the radio buttons look and feel, in line with the v5.4.0 design examples.
* Added additional functions to the `run_example` for ease of testing.
* Added the contents_links() function as a helper for getting the styling and behaviour for left navigation.


# shinyGovstyle 0.0.8

* Update the css to v4.0.0 and made fixes associated with that.
* One of the major changes in the css is a change in look for the accordion.
* Added new functions `gov_main_layout`, `gov_row`, `gov_box` and `gov_text` to 
give better control over the layouts.
* Added tabs as a component using the `govTab` command.
* Added summary list as a component using the `gov_summary` command.
* Added error summary component (`error_summary`) and error summary 
update (`error_summary_update`).


# shinyGovstyle 0.0.7

* Improved the header so that you can adjust the logo size to suit.
* Fix some errors that appeared in the footer.
* Fix the word count function so that you only need to enter word count limit 
  on the `text_area` function.  You can change the limit on `word_count` if 
  needed.
* Change the `run_example` to a better versions that show more ways you can you
  the package.
* Change the `backlink_Input` to a button so that you can use server to move
  between panels etc.
* Added tags through the `tag_Input` function plus added to the `use_example`.
* Added cookie banner through the `cookieBanner` function.
* Added accordion through the `accordion` function.
* Added tables through the `govTable` function.

# shinyGovstyle 0.0.6

* Fix minor bugs from the issues list including data default and radio default.
* Added units test.
* Added an example function.
* Added a `NEWS.md` file to track changes to the package.
* Added a notification banner function.
* Got ready for CRAN release.
* Added output value to the documentation.
