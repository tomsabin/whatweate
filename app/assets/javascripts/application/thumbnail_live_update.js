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
      $(".event-thumbnail__title").text($(this).val());
    });
  };

  var _updateDate = function(){
    $(".event_date input").focusout(function (e) {
      var datetime = moment(new Date($(this).val())).format("Do MMMM YYYY h:mma")
      $(".event-thumbnail__date").text(datetime);
    });
  };

  var _updatePrice = function(){
    $(".event_price input").focusout(function (e) {
      $(".event-thumbnail__price-label").text("£"+$(this).val());
    });
  };

  var _updateShortDescription = function(){
    $(".event_short_description input").focusout(function (e) {
      $(".event-thumbnail__short-description").text($(this).val());
    });
  };

  var _updateLocation = function(){
    $(".event_location input").focusout(function (e) {
      $(".event-thumbnail__location").text($(this).val());
    });
  };

  return {
    init: init
  };
}();
