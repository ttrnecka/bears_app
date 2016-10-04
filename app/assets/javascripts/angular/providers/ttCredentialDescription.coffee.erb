@bearsNg.directive 'ttCredentialDescription', ["$q", "$http","Restangular", ($q,$http,Restangular) ->
  {
    restrict: "A"
    require: 'ngModel'
    link: (scope, elm, attrs, ctrl) ->
      initial_value = null
      ctrl.$asyncValidators.descriptionasync = (modelValue, viewValue) ->
        initial_value = viewValue if initial_value==null
        if ctrl.$isEmpty(modelValue) or initial_value==viewValue
         # consider empty or initial model valid
          return $q.when()

        Restangular.all("admin/credentials").customGET("search", {description: viewValue}).then (credentials) ->
            if credentials.length > 0
              return $q.reject("The credential description is already taken!")
            else
              return $q.resolve()
          , (result) ->
            return $q.reject("Unexpected error!")
	
  }
]