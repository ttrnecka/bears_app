class Plotter
  default_options = {
    grid:
      hoverable: true
      clickable: true
    legend:
       	sorted: true
    tooltip: true
    tooltipOpts:
      shifts:
        x: 20
        y: 0
  }
  pie_chart: (jquery_selector,data,options = {}) ->
    chart_defaults = {
      series:
        pie: 
          show: true
      tooltipOpts:
        content: "%p.0%, %n TB, %s", # show percentages, rounding to 2 decimal places
    }
    merged_options = $.extend({},default_options,chart_defaults,options)
    return $.plot(jquery_selector, data, merged_options)
    
  stack_chart: (jquery_selector,data,options = {}) ->
    chart_defaults = {
      series:
        stack: true
        bars:
          show: true
          barWidth: 1 
      xaxis: 
        ticks: [[1.5, "UK"],[3,"Germany"]]
      yaxis:
        tickFormatter: (val, axis) ->
          return val + " TB"
      tooltipOpts:
        content: "%y TB, %s"
    }
    merged_options = $.extend({},default_options,chart_defaults,options)
    return $.plot(jquery_selector, data, merged_options)
    
window.FlotPlotter = new Plotter()