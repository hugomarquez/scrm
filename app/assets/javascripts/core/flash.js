var Flash = (function(){
  // Cache DOM
  var $flash = $('#flash');

  // Functions
  var searchFlash = function() {
    if ($('#flash').length) {
      newFlash($('#flash'));
    }
  }

  function newFlash(flash) {
    console.log(flash);
    swal({
      title: flash.data('type'),
      text: flash.data('message'),
      type: flash.data('type'),
      timer: 2000
    }).catch(swal.noop);
  }

  return{
    searchFlash:searchFlash
  };

})();
