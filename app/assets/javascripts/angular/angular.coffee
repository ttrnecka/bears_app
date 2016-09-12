@bearsNg = angular.module("bearsApp",["ui.bootstrap","restangular","datatables","templates","ngSanitize"])

# Global configuration
@bearsNg.config (RestangularProvider) ->
  RestangularProvider.setRequestSuffix('.json')

# factory
@bearsNg.factory "flash", ["$timeout", ($timeout)->
  currentMessage = ""
  type=-1
  types=['Error',"Success","Info"]
  default_timeout=10
  timeout=null

  flash = {
    setMessage: (message,mType)->
      currentMessage=message;
      type = $.inArray(mType,types)
      
      if default_timeout>0
        flash.clear_in(default_timeout);
      return

    getMessage: ->
      currentMessage
      
    show: ->
       if type < -1 then "" else  types[type]
      
    clear: ->
      currentMessage = ""
      type = -1
      timeout=null

    clear_in: (secs) ->
      if timeout!=null
        $timeout.cancel(timeout)
        
      timeout = $timeout(flash.clear, secs*1000)

    setTimeout: (secs)->
      default_timeout=secs;
  }
]

# this is general error handler for httpProvider 
@bearsNg.factory 'errorHandler', ['$q', '$location','flash','$window', ($q, $location,flash,$window) ->
  errorHandler = {
    responseError: (response) ->
    # not authorized
      if response.status == 401
        alert("Not logged in - redirecting to sing in page")
        $window.location.href="/signin"
    
      if response.status == 403
        alert("Access forbidden")
        $window.location.href="/"
    
      if response.status == 500
        flash.setMessage("Internal Server Error","Error")
      return $q.reject(response)
  }
]

@bearsNg.config ['$httpProvider', ($httpProvider)->
  $httpProvider.interceptors.push('errorHandler')
]

@bearsNg.directive 'ttFlash', ['flash', (flash) ->
  dir = {
    restrict: 'E',
    controller: [ "$scope","flash", ($scope,flash) ->
      $scope.flash = flash
    ]
    template: '<div class="row alert alert-success" ng-show="flash.show()==\'Success\'" ng-bind-html="flash.getMessage()"></div>' + 
      '<div class="row alert alert-danger" ng-show="flash.show()==\'Error\'" ng-bind-html="flash.getMessage()"></div>' +
   	  '<div class="row alert alert-info" ng-show="flash.show()==\'Info\'" ng-bind-html="flash.getMessage()"></div>'
  }
]
