var lookup = (function(){
  // Cache DOM
  var $type = $('#polymorphic_select')
  var $lookupBtn = $('#relatedToBtn');

  // Datatables
  var $usersDatatable = $('#usersDatatable');
  var $leadsDatatable = $('#leadsDatatable');
  var $accountsDatatable = $('#accountsDatatable');
  var $contactsDatatable = $('#contactsDatatable');
  var $dealsDatatable = $('#dealsDatatable');

  // Btn Targets
  var accountsTarget = '#accountsLookup';
  var leadsTarget = '#leadsLookup';
  var contactsTarget = '#contactsLookup';
  var dealsTarget = '#dealsLookup';


  // Bind Events
  $type.on('change', toggleModal);

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

  function toggleModal(){
    if ($type.val() == 'Crm::Account') {
      toggleBtnData(accountsTarget);
      set_or_initialize_dataTable($accountsDatatable);

    } else if($type.val() == 'Crm::Contact') {
      toggleBtnData(contactsTarget);
      set_or_initialize_dataTable($contactsDatatable);

    } else if($type.val() == 'Crm::Lead') {
      toggleBtnData(leadsTarget);
      set_or_initialize_dataTable($leadsDatatable);

    } else if ($type.val() == 'Crm::Deal') {
      toggleBtnData(dealsTarget);
      set_or_initialize_dataTable($dealsDatatable);
    }
  }

  function toggleBtnData(target){
    $lookupBtn.attr('data-target', target);
  }

  function setAjaxDataTable(resource){
    let language_url = "";
    if(i18n.get() == "es") {
      language_url = "/es.json";
    }
    resource.dataTable({
      pagingType: "full_numbers",
      jQueryUI: true,
      processing: true,
      serverSide: true,
      language: {
        url: language_url
      },
      ajax:{
        url: resource.data('source'),
        type: 'GET',
        beforeSend:function (request) {
          request.setRequestHeader("X-API-EMAIL", resource.data('email'));
          request.setRequestHeader("X-API-TOKEN", resource.data('token'));
        }
      }
    });

    $('.table').parent().addClass('table-responsive');
  }

  function set_or_initialize_dataTable(datatable_id){
    if ( !$.fn.DataTable.isDataTable(datatable_id) ) {
      setAjaxDataTable(datatable_id);
    }
  }

  setAjaxDataTable($usersDatatable);
  toggleModal();

  return{
    start: start
  };
})();
