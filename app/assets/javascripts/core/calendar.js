var calendar = (function(){

  function init(){
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
        events:'/tasks.json'
      });
    });
  }

  return{
    init : init
  };

})();

$(document).ready(function(){
  calendar.init();
});
