$(document).ready(function() {
  $.get("/gh-data/languages", function(response) {
      var langData = []
      for (key in response) {
        // for each thing in this loop it's going to push into
        // new array in format that Highcharts can read.
        langData.push({name: key, y: response[key]})
      };

      $("#chart-1").highcharts({
      title: {
        text: "Languages"
      },
      chart: {
        type: "pie"
      },
      series: [{
        name: "Languages",
        data: langData
      },
      ]
    });
  });

  $.get("/gh-data/events", function(response) {
      var eventData = []
      for (key in response) {
        eventData.push({name: key, y: response[key]})
      };

      $("#chart-2").highcharts({
      title: {
        text: "Events"
      },
      chart: {
        type: "pie"
      },
      series: [{
        name: "Events",
        data: eventData
      },
      ]
    });
  });
});
