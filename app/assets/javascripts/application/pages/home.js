module("pages-home", function (module) {
  module.exports = (function(){
    $('label[for="guests"]').addClass('active');
    $(".toggle").change(function(e) {
      var $labels = $(".how-it-works label");
      $labels.removeClass("active");
      $labels.filter('label[for="'+e.target.id+'"]').addClass("active");
    });
  })();
});
