# provide id of element in table attribute
@bearsNg.directive 'bearsDataTable', ["bearsDataTablesService", (bearsDataTablesService) ->
  restrict: 'E',
  link: (scope, element, attrs) ->
    bearsDataTablesService.create attrs.table
]