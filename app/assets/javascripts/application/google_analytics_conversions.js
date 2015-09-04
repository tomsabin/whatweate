var googleAnalyticsConversions = function(){
  var init = function(){
    $("[data-ga]").on("click", function(){
      switch(this.getAttribute("data-ga")){
        case "conversion":
          ga("send", "event", "conversion", "click", $(this).text().trim());
          break;
        case "events":
          ga("send", "event", "events", "click", this.getAttribute("title"));
          break;
        case "social":
          ga("send", "event", "social", "click", $(this).text().trim());
          break;
      };
    });
  };

  return {
    init: init
  };
}();
