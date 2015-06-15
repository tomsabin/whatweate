module("shared", function (module) {
  var navigation = function () {
    $('a[href^="/#"]').click(function () {
      $("html, body").animate({
        scrollTop: $('[name="' + $.attr(this, 'href').substr(2) + '"]').offset().top - 90
      }, 500);
      return false;
    });
  };

  var newsletter = function () {
    $("#newsletter").ajaxChimp({
      url: "http://whatweate.us9.list-manage.com/subscribe/post?u=3ae9a01a53d464033afcc3009&id=eb7d06a555",
      callback: function (data) {
        ga("send", "event", "newsletter", "submit", "fill in newsletter");
        $("#response").text(data.msg);
      }
    });
  };

  module.exports = (function(){
    navigation();
    newsletter();
  })();
});
