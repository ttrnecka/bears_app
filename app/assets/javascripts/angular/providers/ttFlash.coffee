@bearsNg.factory "flash", ["$timeout", ($timeout)->
  currentMessage = ""
  types=['Danger','Warning','Success','Info']
  timeout=null
  type =""
  flash = {}

  define = (ftype) ->
    flash["report"+ftype] = (msg,timeout=10) ->
      currentMessage = msg
      type = ftype
      flash.clear_in(timeout)
      return
    flash["is"+ftype] = ->
      ftype == type
  
  flash.isMessage = () ->
    currentMessage != ""
    
  flash.getMessage = ->
    currentMessage
      
  flash.clear = ->
    currentMessage = ""
    type = ""
    timeout=null

  flash.clear_in = (secs) ->
    if timeout!=null
      $timeout.cancel(timeout)        
    timeout = $timeout(flash.clear, secs*1000)
  
  define type for type in types
  
  return flash
]

@bearsNg.directive 'ttFlash', ['flash', (flash) ->
  dir = {
    restrict: 'E'
    replace: true
    controller: [ "$scope", ($scope) ->
      $scope.flash = flash
    ]
    template: '<div class="row alert" ng-class="{\'alert-info\': flash.isInfo(),\'alert-success\': flash.isSuccess(),\'alert-danger\': flash.isDanger(),\'alert-warning\': flash.isWarning() }" ng-show="flash.isMessage()" ng-bind-html="flash.getMessage()"></div>'
  }
]