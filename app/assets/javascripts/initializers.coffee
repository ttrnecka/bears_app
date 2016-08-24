window.data_tables =
  users_table: null
  
document.addEventListener("turbolinks:load", ->
  window.data_tables.users_table = $('#users_table').DataTable({
  	info:"Users"
  })
  	
  # metis menu
  $('#side-menu').metisMenu()
  url = window.location
  element = $('ul.nav a')
  .filter( -> 
    return this.href == url.href
  )
  .addClass 'active'
  .parents 'ul'
  .addClass 'in'
  
  element.addClass 'active' if element.is 'li' 
  return
)

document.addEventListener("turbolinks:before-cache", ->
  window.data_tables.users_table.destroy() if $('#users_table_wrapper').length == 1
  return
)