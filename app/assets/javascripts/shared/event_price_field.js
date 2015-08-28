var eventPriceField = function(){
  var onChange = function(selector){
    $(selector).change(function(){
      this.value = parseFloat(this.value).toFixed(2);
    })
  }

  return {
    onChange: onChange
  };
}();
