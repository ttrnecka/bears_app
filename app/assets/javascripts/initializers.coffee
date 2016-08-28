window.data_tables =
  users_table: null

document.addEventListener("turbolinks:load", ->
  # user menu
  window.data_tables.users_table = $('#users_table').DataTable({
    stateSave: true
  })
  
  # metis menu
  $('#side-menu').metisMenu()
  # section highligh
  url = window.location
  element = $('ul.nav a')
  .filter( ->
    return url.href == this.href
  )
  .addClass 'active'
  .parents 'ul'
  .addClass 'in'
  
  element.addClass 'active' if element.is 'li' 
  return
)

document.addEventListener("turbolinks:before-cache", ->
  # destroy users_table to make sure the HTML does not duplicate
  window.data_tables.users_table.destroy() if $('#users_table_wrapper').length == 1
  return
)