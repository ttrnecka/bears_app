@bearsNg.controller "Admin::CredentialCtrl", [ 'Restangular', '$uibModal', "flash", "DTOptionsBuilder", (Restangular,$uibModal,flash,DTOptionsBuilder) ->
   ctrl=@
   ctrl.dtInstance = {}
   ctrl.animationsEnabled = true
   ctrl.dtOptions = DTOptionsBuilder.newOptions().withDOM("<'row'<'col-sm-5'l><'col-sm-2'B><'col-sm-5'f>>" + "<'row'<'col-sm-12'tr>>" + "<'row'<'col-sm-5'i><'col-sm-7'p>>").withButtons [
     {
       text: "New Credential"
       className: "btn-primary"
       action: (e, dt, node, config) ->
         ctrl.add()
     }
   ]
   
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
   
   ctrl.add = () ->
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
            return {
              password: ""
              password_confirmation: ""
            }
          title: ->
            return "New"
          mode: ->
            return "create"
        }
      }

     modalInstance.result.then (credential) ->
       credentials.post(credential).then (response)->
         flash.setMessage("Credential has been successfully created!!!","Success")
         ctrl.credentials.unshift(response)
       , (result)->
         flash.setMessage("Adding credential failed: "+result.data.errors,"Error")    
   
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
          title: ->
            return "Edit"
          mode: ->
            return "edit"
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

@bearsNg.controller 'credentialEditCtrl', [ "$uibModalInstance", "credential","title","mode",($uibModalInstance, credential, title, mode) ->
  ctrl = @
  ctrl.credential = credential
  ctrl.title = title
  if mode
    ctrl.mode = mode
  else
    ctrl.mode = "edit"
  
  ctrl.save_disabled = ->
    ctrl.credential.password != ctrl.credential.password_confirmation || ctrl.form.$invalid
  
  ctrl.password_ok = ->
    ctrl.credential.password == ctrl.credential.password_confirmation
      
  ctrl.save = ->
    $uibModalInstance.close(ctrl.credential)

  ctrl.cancel = ->
    $uibModalInstance.dismiss('cancel')
  
  return
]