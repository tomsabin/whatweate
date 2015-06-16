module("google_analytics", function(module) {
  var initialize = (function(i,s,o,g,r,a,m){
    i["GoogleAnalyticsObject"]=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,"script","//www.google-analytics.com/analytics.js","ga");

  var on_click_conversions = function () {
    $("[data-ga]").on("click", function () {
      switch(this.getAttribute("data-ga")) {
        case "conversion":
          ga("send", "event", "conversion", "click", $(this).text().trim());
          break;
        case "events":
          ga("send", "event", "events", "click", this.getAttribute("title"));
          break;
        case "social":
          ga("send", "event", "social", "click", $(this).text().trim());
          break;
      }
    });
  }

  module.exports = (function(){
    initialize;
    ga("create", "<%= Settings.ga_tracking_id %>", "auto");
    ga("send", "pageview");
    on_click_conversions();
  })()
});
