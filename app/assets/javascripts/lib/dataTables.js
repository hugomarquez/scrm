var dataTables = (function(){
  // cache DOM
  var $ajax_data_table = $('.ajax-data-table');
  var $data_table = $('.data-table');
  // functions
  function setAjaxDataTable(){
    let language_url = "";
    if(i18n.get() == "es") {
      language_url = "/es.json";
    }
    $ajax_data_table.dataTable({
      pagingType: "full_numbers",
      jQueryUI: true,
      processing: true,
      serverSide: true,
      language: {
        url: language_url
      },
      ajax:{
        url: $ajax_data_table.data('source'),
        type: 'GET',
        beforeSend:function (request) {
          request.setRequestHeader("X-API-EMAIL", $ajax_data_table.data('email'));
          request.setRequestHeader("X-API-TOKEN", $ajax_data_table.data('token'));
        }
      }
    });
    $('.table').parent().addClass('table-responsive');
  }
  
  setAjaxDataTable();
  return{};
})();
