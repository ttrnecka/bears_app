window.plotter =
  pie_chart: (jquery_selector,data) ->
    plotObj = $.plot($("#chart_capacity"), data, {
      series:
        pie: 
          show: true
      grid:
        hoverable: true
        clickable: true
      tooltip: true,
      tooltipOpts:
        content: "%p.0%, %s", # show percentages, rounding to 2 decimal places
        shifts:
          x: 20,
          y: 0
        defaultTheme: false
    })
    
    jquery_selector.bind("plotclick", (event, pos, item) ->
      console.log(item) if item
      return
    )
    return plotObj