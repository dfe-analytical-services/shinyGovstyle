// update_page_title JS
//
// Sets document.title from the R server. The composed title string is
// built server-side in update_page_title(); this handler simply applies it.

Shiny.addCustomMessageHandler("update_page_title", function (title) {
  document.title = title;
});
