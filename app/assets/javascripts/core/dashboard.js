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
    let stages = [];
    let expected = [];
    let amount = [];
    let labels = deals[deals.length -1].labels;

    for(let d = 0; d < deals.length -1; d++) {
      stages.push(deals[d].stage);
      amount.push(deals[d].amount);
      expected.push(deals[d].expected_revenue);
    }

    data = {
      labels: stages,
      datasets:[
        {
          label: labels.amount,
          data: amount,
          backgroundColor: colors.material.blue
        },
        {
          label: labels.expected_revenue,
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

  function funnelChart() {
    var deals = $("#dealsFunnel").data("deals");
    let labels = [];
    let data = [];
    let ctx = document.getElementById("dealsFunnel").getContext("2d");

    for(let d = 0; d < deals.length; d++) {
      labels.push(deals[d].stage);
      data.push(deals[d].total_stage)
    }
    console.log(deals);
    var config = {
        type: 'funnel',
        data: {
            datasets: [{
                data: data,
                backgroundColor: colors.getMaterialColors(),
            }],
            labels: labels
        },
        options: {
            sort: 'desc',
        }
    };
    let chart = new Chart(ctx, config);
  }

  return{
    dealChart : dealChart,
    amountVexpected : amountVexpected,
    funnelChart : funnelChart
  };

})();

$(document).ready(function(){
  dashboard.dealChart();
  dashboard.amountVexpected();
  dashboard.funnelChart();
});
