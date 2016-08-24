window.data_tables =
  users_table: null
  
document.addEventListener("turbolinks:load", ->
  window.data_tables.users_table = $('#users_table').DataTable()
  	
  # metis menu
  $('#side-menu').metisMenu()
  url = window.location
  element = $('ul.nav a')
  .filter( -> 
    return this.href == url
  )
  .addClass 'active'
  .parents 'ul'
  .addClass 'in'
  
  element.addClass 'active' if element.is 'li' 
)

document.addEventListener("turbolinks:before-cache", ->
  window.data_tables.users_table.destroy() if $('#users_table_wrapper').length == 1
)