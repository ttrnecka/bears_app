@bearsNg.factory "ttspinner", [->
  spinner = {
    show: () ->
      spinner.state = true
    hide: () ->
      spinner.state = false
    state: false
  }
]

@bearsNg.directive 'ttSpinner', ["ttspinner", (ttspinner) ->
  {
    restrict: "E"
    templateUrl: 'modals/spinnerModal.html'
    replace:true
    controller: [ "$scope", ($scope) ->
      $scope.spinner = ttspinner
    ]
    link: (scope, elm, attrs, ctrl) ->
      scope.$watch('spinner.state', (newvalue,oldvalue) ->
        if newvalue==true
          elm.modal("show")
        if newvalue==false
          elm.modal("hide") 
      )
  }
]