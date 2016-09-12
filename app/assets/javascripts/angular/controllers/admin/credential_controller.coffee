@bearsNg.controller "Admin::CredentialCtrl", [ 'Restangular', '$uibModal', (Restangular,$uibModal) ->
   ctrl=@
   ctrl.dtInstance = {}
   ctrl.animationsEnabled = true 
     
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
          flash.setMessage("Credential Removed","Success")
        , (result)->
          flash.setMessage(result.data.error,"Error")
     
   ctrl.edit = (credential) ->
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
        console.log credential
   return  
]

@bearsNg.controller 'credentialEditCtrl', [ "$uibModalInstance", "credential",($uibModalInstance, credential) ->
  ctrl = @
  ctrl.credential = credential
  
  ctrl.save_disabled = ->
    ctrl.credential.password != ctrl.credential.password_confirmation
    
  ctrl.save = ->
    $uibModalInstance.close(ctrl.credential)

  ctrl.cancel = ->
    $uibModalInstance.dismiss('cancel')
  
  return
]