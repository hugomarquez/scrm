var lookup = (function(){

  // functions
  function start(e){
    console.log(e);
    var $modal = findParentNode('modal', e);
    $modal.modal('hide');
    var $hiddenField = $('#'+$modal.data('input'));
    var $labelField = $('#'+$modal.data('label'));
    var $id = $(e).data('resource');
    var $label = $(e).data('label');
    $hiddenField.val($id);
    console.log($hiddenField);
    $labelField.val($label);
  }

  function findParentNode(parentClass, childObj){
    var obj = $(childObj).parent();
    var count = 1;
    while(!obj.hasClass(parentClass)) {
      obj = obj.parent();
      count++;
    }
    return obj;
  }

  return{
    start: start
  };
})();
