window.bearsApp =
  data_tables:
    users_table: null
  utils:
    locationHref: ()->
      window.location.href

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