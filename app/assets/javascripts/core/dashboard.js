var dashboard = (function(){

  function dealChart() {
    var deals = $("#dealsByStages").data("deals");
    let ctx = document.getElementById("dealsByStages").getContext("2d");
    let labels = [];
    let total_stage = [];

    for(let d in deals) {
      labels.push(deals[d].stage);
      total_stage.push(deals[d].total_stage);
    }
    data = {
      labels: labels,
      datasets:[{
        data: total_stage,
        backgroundColor: colors.getMaterialColors()
      }],
    }

    options = {}

    let chart = new Chart(ctx, {type:"doughnut", data: data, options: options});
  }

  function amountVexpected(){
    var deals = $("#dealsAmountExpected").data("deals");
    let ctx = document.getElementById("dealsAmountExpected").getContext("2d");
    let labels = [];
    let expected = [];
    let amount = [];

    for(let d in deals) {
      labels.push(deals[d].stage);
      amount.push(deals[d].amount);
      expected.push(deals[d].expected_amount);
    }

    data = {
      labels: labels,
      datasets:[
        {

          data: amount,
          backgroundColor: colors.material.blue
        },
        {

          data: expected,
          backgroundColor: colors.material.green
        },
      ],
    }

    options = {
      legend: {
        display: false
      },
      barValueSpacing: 20,
      scales: {
        yAxes: [{
          ticks: {min: 0,}
        }]
      }
    }

    let chart = new Chart(ctx, {type:"bar", data: data, options: options});
  }

  return{
    dealChart : dealChart,
    amountVexpected : amountVexpected
  };

})();

$(document).ready(function(){
  dashboard.dealChart();
  dashboard.amountVexpected();
});
