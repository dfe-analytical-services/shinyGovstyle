// update_page_title JS
//
// Sets document.title from the R server. The composed title string is
// built server-side in update_page_title(); this handler simply applies it.

Shiny.addCustomMessageHandler("update_page_title", function (title) {
  document.title = title;
  // Stops a nav sync for a tab change in the same server update overwriting
  // this title. service_navigation.js drops the flag otherwise.
  window.shinyGovstyleServerTitle = true;
});
