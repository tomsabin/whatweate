$(document).ready(function () {
  $('a[href^="#"]').click(function (e) {
    $('html, body').animate({
      scrollTop: $('[name="' + $.attr(this, 'href').substr(1) + '"]').offset().top - 90
    }, 500);
    return false;
  });

  // Section: newsletter
  $('#newsletter').ajaxChimp({
    url: 'http://whatweate.us9.list-manage.com/subscribe/post?u=3ae9a01a53d464033afcc3009&id=eb7d06a555',
    callback: function (data) {
      ga('send', 'event', 'newsletter', 'submit', 'fill in newsletter');
      $('#response').text(data.msg);
    }
  });

  // Section: how it works
  $('label[for="guests"]').addClass('active');
  $('.toggle').change(function(e) {
    var $labels = $('.how-it-works label');
    $labels.removeClass('active');
    $labels.filter('label[for="'+e.target.id+'"]').addClass('active');
  });
});
