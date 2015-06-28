var thumbnailLiveUpdate = function(){
  var init = function(){
    _updateTitle();
    _updateDate();
    _updatePrice();
    _updateShortDescription();
    _updateLocation();
  };

  var _updateTitle = function(){
    $(".event_title input").focusout(function (e) {
      $(".event-thumbnail h2").text($(this).val());
    });
  };

  var _updateDate = function(){
    $(".event_date input").focusout(function (e) {
      var datetime = moment(new Date($(this).val())).format("Do MMMM YYYY h:mma")
      $(".event-thumbnail span.date").text(datetime);
    });
  };

  var _updatePrice = function(){
    $(".event_price input").focusout(function (e) {
      $(".event-thumbnail span.price").text("£"+$(this).val());
    });
  };

  var _updateShortDescription = function(){
    $(".event_short_description input").focusout(function (e) {
      $(".event-thumbnail .short-description").text($(this).val());
    });
  };

  var _updateLocation = function(){
    $(".event_location input").focusout(function (e) {
      $(".event-thumbnail .venue").text($(this).val());
    });
  };

  return {
    init: init
  };
}();
