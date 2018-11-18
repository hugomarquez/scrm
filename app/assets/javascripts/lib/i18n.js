var i18n = (function(){

  // Functions
  var get = function() {
    return $("html").attr("lang");
  }
  return{
    get : get
  };

})();
