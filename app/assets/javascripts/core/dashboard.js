var dashboard = (function(){

  function initCalendar(){
    $('.calendar').each(function(){
      var calendar = $(this);
      calendar.fullCalendar({
        locale: i18n.get(),
        header: {
          left: 'prev,next today',
          center: 'title',
          right: 'month,agendaWeek,agendaDay'
        },
        selectable: true,
        selectHelper: true,
        eventLimit: true,
      });
    });
  }


  return{
    initCalendar : initCalendar
  };

})();

$(document).ready(function(){
  dashboard.initCalendar();
});
