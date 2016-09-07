@bearsNg.service 'bearsDataTablesService', [->
  
  # private variables
  tables = []
  selectors = []
  init = ->
    document.addEventListener "turbolinks:before-cache", ->
      table.destroy() for table in tables
      $('#'+identifier).hide() for identifier in selectors
      return
  
  @create = (identifier, options = {}) =>
    dt = $('#'+identifier).DataTable(options)
    $('#'+identifier).show()
    tables.push dt
    selectors.push identifier
    return dt
    
  init()
  return
]