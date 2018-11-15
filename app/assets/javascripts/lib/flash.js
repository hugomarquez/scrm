var flash = (function(){

  // Functions
  var search = function() {
    let f = $('#flash');
    if (f.length) {
      let type = f.data("type");
      let message = f.data("message");

      if(type == "notice" || type == "alert") {
        flash("info", message);
      } else {
        flash(type, message);
      }
    }
  }

  function flash(type, message) {
    swal({
      text: message,
      type: type,
      timer: 2000,
    }).catch(swal.noop);
  }

  return{
    search:search
  };

})();
