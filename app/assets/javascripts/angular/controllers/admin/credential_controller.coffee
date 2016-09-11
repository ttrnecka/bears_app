@bearsNg.controller "Admin::CredentialCtrl", [ '$scope','Restangular', '$uibModal', ($scope,Restangular,$uibModal) ->
   ctrl=@
   ctrl.dtInstance = {}
   ctrl.animationsEnabled = true
   
   credentials = Restangular.all('admin/credentials.json')
   credentials.getList()
     .then (credentials) ->
       ctrl.credentials = credentials
         
   ctrl.delete = (credential) ->
      modalInstance = $uibModal.open {
        animation: ctrl.animationsEnabled,
        ariaLabelledBy: 'modal-title',
        ariaDescribedBy: 'modal-body',
        templateUrl: 'YesNoModal.html',
        controller: 'YesNoModalCtrl',
        controllerAs: 'ctrl',
        size: "sm",
        resolve: {
          question: ->
            return "Do you want to delete the credential "+credential.description
        }
      }

      modalInstance.result.then (answer) ->
        console.log answer
     
   ctrl.edit = (credential) ->
      console.log credential
      modalInstance = $uibModal.open {
        animation: ctrl.animationsEnabled,
        ariaLabelledBy: 'modal-title',
        ariaDescribedBy: 'modal-body',
        templateUrl: 'credentialEdit.html',
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

  ctrl.save = ->
    $uibModalInstance.close(ctrl.credential)

  ctrl.cancel = ->
    $uibModalInstance.dismiss('cancel')
  
  return
]

@bearsNg.controller 'YesNoModalCtrl', [ "$uibModalInstance", "question",($uibModalInstance, question) ->
  ctrl = @
  ctrl.question = question

  ctrl.yes = ->
    $uibModalInstance.close('yes')

  ctrl.no = ->
    $uibModalInstance.close('no')
  
  return
]