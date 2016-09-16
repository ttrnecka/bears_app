@bearsNg.controller "Admin::CredentialCtrl", [ 'Restangular', '$uibModal', "flash", "DTOptionsBuilder","ttspinner", (Restangular,$uibModal,flash,DTOptionsBuilder,ttspinner) ->
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
   ttspinner.show()
   credentials.getList()
     .then (credentials) ->
       ttspinner.hide()
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
        if answer=="yes"
          credential.remove().then ->
            flash.reportSuccess("Credential has been successfully removed!!!")
            delete_from ctrl.credentials, credential
          , (result)->
            flash.reportDanger(result.data.errors)
   
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
          data: ->
            return {
              credential: {
                password: ""
                password_confirmation: ""
              }
              mode: "new"
            }
        }
      }

     modalInstance.result.then (credential) ->
       credentials.post(credential).then (response)->
         flash.reportSuccess("Credential has been successfully created!!!")
         ctrl.credentials.unshift(response)
       , (result)->
         flash.reportDanger("Adding credential failed: "+result.data.errors)    
   
   ctrl.edit = (credential) ->
      initial_credential = angular.copy(credential)
      credential.password = ""
      credential.password_confirmation = ""
      modalInstance = $uibModal.open {
        animation: ctrl.animationsEnabled,
        ariaLabelledBy: 'modal-title',
        ariaDescribedBy: 'modal-body',
        templateUrl: 'admin/credentials/edit.html',
        controller: 'credentialEditCtrl',
        controllerAs: 'ctrl',
        size: null,
        resolve: {
          data: ->
            return {
              credential: credential
              mode: "edit"
            }
        }
      }

      modalInstance.result.then (credential) ->
          credential.patch().then ->
            flash.reportSuccess("Credential has been successfully updated!!!")
            delete credential.password
            delete credential.password_confirmation
          , (result)->
            angular.copy(initial_credential,credential)
            flash.reportDanger("Update failed: "+result.data.errors)
       , (type) ->
         angular.copy(initial_credential,credential)  
   return  
]

@bearsNg.controller 'credentialEditCtrl', [ "$uibModalInstance", "data",($uibModalInstance, data) ->
  ctrl = @
  ctrl.credential = data.credential
  ctrl.mode = data.mode
  ctrl.title = data.mode.charAt(0).toUpperCase() + data.mode.slice(1)
  
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