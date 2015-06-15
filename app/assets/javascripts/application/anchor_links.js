module("anchor_links", function (module) {
  module.exports = (function(){
    $('a[href^="/#"]').click(function () {
      $("html, body").animate({
        scrollTop: $('[name="' + $.attr(this, 'href').substr(2) + '"]').offset().top - 90
      }, 500);
      return false;
    });
  })();
});
