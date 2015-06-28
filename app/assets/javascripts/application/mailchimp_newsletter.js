var mailChimpNewsletter = function(){
  var init = function(formSelector, responseSelector){
    $(formSelector).ajaxChimp({
      url: "http://whatweate.us9.list-manage.com/subscribe/post?u=3ae9a01a53d464033afcc3009&id=eb7d06a555",
      callback: function(data){
        ga("send", "event", "newsletter", "submit", "fill in newsletter");
        $(responseSelector).text(data.msg);
      }
    });
  };

  return {
    init: init
  };
}();
