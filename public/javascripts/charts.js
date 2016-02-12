$(document).ready(function() {
  $.get("/gh-data", function(response) {
      console.log(response);
      var pieData = response.map(function(pie) {
        // for each thing in this loop it's going to push into new array
        return {name: pie.flavor, y: pie.votes}
      });

      $("#chart-container").highcharts({
      title: {
        text: "Top Pies, Feb 2016"
      },
      chart: {
        type: "pie"
      },
      series: [{
        name: "Sales: Sweet",
        data: pieData
      },
      ]
    });
  });
});
