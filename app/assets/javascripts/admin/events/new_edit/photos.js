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
            var src = e.target.result;
            var id = "photo-" + (index + 1);
            $container.append('<img src="' + src +'" alt="Event photo" class="responsive-img" id="' + id + '">');
          }

          reader.readAsDataURL(file);
        });
      }
    });
  })();
});
