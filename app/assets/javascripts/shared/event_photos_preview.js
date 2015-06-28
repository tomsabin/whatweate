var eventPhotosPreview = function(){
  var init = function(selectors, materialize){
    $(selectors.input).change(function () {
      var input = this;
      var fileCount = input.files.length;
      var $container = $(selectors.container);
      $container.empty();

      if (input.files && fileCount >= 2 && fileCount <= 6) {
        $.each(input.files, function (index, file) {
          var reader = new FileReader();

          reader.onload = function (e) {
            var src = e.target.result;
            if (materialize){
              var id = "photo-" + (index + 1);
              $container.append('<img src="' + src +'" alt="Event photo" class="responsive-img event-photo" id="' + id + '">');
            } else {
              $container.append('<img src="' + src +'">');
            }
          }

          reader.readAsDataURL(file);
        });
      }
    });
  };

  return {
    init: init
  };
}();
