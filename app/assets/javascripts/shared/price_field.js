module("event_price_field", function (module) {
  module.exports = (function(){
    $("#event_price").change(function () {
      this.value = parseFloat(this.value).toFixed(2);
    });
  })();
});
