$(document).ready(function () {
  $('[data-ga]').on('click', function () {
    switch(this.getAttribute('data-ga')) {
      case 'conversion':
        ga('send', 'event', 'conversion', 'click', $(this).text().trim());
      case 'events':
        ga('send', 'event', 'events', 'click', this.getAttribute('title'));
      case 'social':
        ga('send', 'event', 'social', 'click', $(this).text().trim());
    }
  });
});
