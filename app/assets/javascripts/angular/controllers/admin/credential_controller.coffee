@bearsNg.controller "Admin::CredentialCtrl", [ 'Restangular', '$uibModal', "flash", (Restangular,$uibModal,flash) ->
   ctrl=@
   ctrl.dtInstance = {}
   ctrl.animationsEnabled = true
   
   delete_from = (array,obj) ->
     index = array.indexOf(obj)
     array.splice(index,1)
   
   credentials = Restangular.all('admin/credentials')
   credentials.getList()
     .then (credentials) ->
       ctrl.credentials = credentials
     
   ctrl.delete = (credential) ->
      modalInstance = $uibModal.open {
        animation: ctrl.animationsEnabled,
        ariaLabelledBy: 'modal-title',
        ariaDescribedBy: 'modal-body',
        templateUrl: 'modals/yesNoModal.html',
        controller: 'YesNoModalCtrl',
        controllerAs: 'ctrl',
        size: "sm",
        resolve: {
          question: ->
            return "Do you want to delete the credential "+credential.description
        }
      }

      modalInstance.result.then (answer) ->
        credential.remove().then ->
          flash.setMessage("Credential has been successfully removed!!!","Success")
          delete_from ctrl.credentials, credential
        , (result)->
          flash.setMessage(result.data.errors,"Error")
     
   ctrl.edit = (credential) ->
      initial_credential = angular.copy(credential)
      modalInstance = $uibModal.open {
        animation: ctrl.animationsEnabled,
        ariaLabelledBy: 'modal-title',
        ariaDescribedBy: 'modal-body',
        templateUrl: 'admin/credentials/edit.html',
        controller: 'credentialEditCtrl',
        controllerAs: 'ctrl',
        size: null,
        resolve: {
          credential: ->
            return credential
        }
      }

      modalInstance.result.then (credential) ->
          credential.patch().then ->
            flash.setMessage("Credential has been successfully updated!!!","Success")
            delete credential.password
            delete credential.password_confirmation
          , (result)->
            angular.copy(initial_credential,credential)
            flash.setMessage("Update failed: "+result.data.errors,"Error")
       , (type) ->
         angular.copy(initial_credential,credential)  
   return  
]

@bearsNg.controller 'credentialEditCtrl', [ "$uibModalInstance", "credential",($uibModalInstance, credential) ->
  ctrl = @
  ctrl.credential = credential
  
  ctrl.save_disabled = ->
    ctrl.credential.password != ctrl.credential.password_confirmation
  
  ctrl.password_ok = ->
    ctrl.credential.password == ctrl.credential.password_confirmation
      
  ctrl.save = ->
    $uibModalInstance.close(ctrl.credential)

  ctrl.cancel = ->
    $uibModalInstance.dismiss('cancel')
  
  return
]