module("thumbnail", function (module) {
  module.exports = (function(){
    $(".event_title input").focusout(function (e) {
      $(".event-thumbnail h2").text($(this).val());
    })
    $(".event_date input").focusout(function (e) {
      var datetime = moment(new Date($(this).val())).format("Do MMMM YYYY h:mma")
      $(".event-thumbnail span.date").text(datetime);
    })
    $(".event_price input").focusout(function (e) {
      $(".event-thumbnail span.price").text("£"+$(this).val());
    })
    $(".event_short_description input").focusout(function (e) {
      $(".event-thumbnail .short-description").text($(this).val());
    })
    $(".event_location input").focusout(function (e) {
      $(".event-thumbnail .venue").text($(this).val());
    })
  })();
});
