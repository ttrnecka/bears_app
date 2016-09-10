@bearsNg.controller "Admin::CredentialCtrl", [ '$scope','Restangular', ($scope,Restangular) ->
   ctrl=@
   ctrl.dtInstance = {}
   Restangular.all('admin/credentials.json').getList()
     .then (credentials) ->
       ctrl.credentials = credentials
   return  
]