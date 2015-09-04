var smoothAnchorLinks = function(){
  var init = function(){
    $('a[href^="/#"]').click(function () {
      $("html, body").animate({
        scrollTop: $('[name="' + $.attr(this, 'href').substr(2) + '"]').offset().top - 90
      }, 500);
      return false;
    });
  };

  return {
    init: init
  };
}();
