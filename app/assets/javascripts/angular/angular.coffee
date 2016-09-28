@bearsNg = angular.module("bearsApp",["ui.bootstrap","restangular","datatables","datatables.buttons","templates","ngSanitize"])

# Global configuration
@bearsNg.config (RestangularProvider) ->
  RestangularProvider.setRequestSuffix('.json')

# this is general error handler for httpProvider 
@bearsNg.factory 'errorHandler', ['$q', '$location','flash','$window', ($q, $location,flash,$window) ->
  errorHandler = {
    responseError: (response) ->
    # not authorized
      if response.status == 401
        $window.alert("Not logged in - redirecting to sing in page")
        $window.location.href="/signin"
    
      if response.status == 403
        $window.alert("Access forbidden")
        $window.location.href="/"
    
      if response.status == 500
        flash.reportDanger("Internal Server Error")
      return $q.reject(response)
  }
]

@bearsNg.config ['$httpProvider', ($httpProvider)->
  $httpProvider.interceptors.push('errorHandler')
]

# pull object from array by id parameter

@bearsNg.filter 'getById', () ->
  (input, id) ->
    i=0
    len=input.length
    for i in [0..len]
      if +input[i].id == +id
        return input[i]
    return null
