window.bearsApp =
  data_tables:
    users_table: null
  utils:
    locationHref: ()->
      window.location.href
    plotter:
      pie_chart: (jquery_selector,data) ->
        plotObj = $.plot(jquery_selector, data, {
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
        return plotObj
      stack_chart: (jquery_selector,data) ->
        plotObj = $.plot(jquery_selector, data, {
          series:
            stack: true
            bars:
              show: true
              barWidth: 1 
          grid:
            hoverable: true
            clickable: true
          xaxis: 
            ticks: [[1.5, "UK"],[3,"Germany"]]
          tooltip: true,
          tooltipOpts:
            content: "%y, %s", # show percentages, rounding to 2 decimal places
            shifts:
              x: 20,
              y: 0
            defaultTheme: false
        })
        return plotObj

app = window.bearsApp

metis_menu =
  highlightSection: ()->
    element = $('ul.nav a')
      .filter ->
        return app.utils.locationHref() == this.href
      .addClass 'active'
      .parents 'ul'
      .addClass 'in'
    element.addClass 'active' if element.is 'li'

document.addEventListener("turbolinks:load", ->
  #angular
  angular.bootstrap document.body, ['bearsApp']
  
  # user menu
  app.data_tables.users_table = $('#users_table').DataTable({
    stateSave: true
  })
  $('#users_table').show()
  
  # metis menu
  $('#side-menu').metisMenu()
  # section highligh
  metis_menu.highlightSection() 
  
  return
)

document.addEventListener("turbolinks:before-cache", ->
  # destroy users_table to make sure the HTML does not duplicate
  if $('#users_table_wrapper').size() == 1
    $('#users_table').hide()
    app.data_tables.users_table.destroy()
  return
)