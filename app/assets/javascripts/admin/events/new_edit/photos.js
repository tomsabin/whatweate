module("photos", function (module) {
  module.exports = (function(){
    $("#event_photos").change(function () {
      var input = this;
      var fileCount = input.files.length;
      var $container = $(".event-photos");
      $container.empty();

      if (input.files && fileCount >= 2 && fileCount <= 6) {
        $.each(input.files, function (index, file) {
          var reader = new FileReader();

          reader.onload = function (e) {
            $container.append('<img class="responsive-img" src="' + e.target.result +'">');
          }

          reader.readAsDataURL(file);
        });
      }
    });
  })();
});
