@bearsNg.controller "Admin::ResourceCtrl", [ 'Restangular', '$uibModal', "flash", "DTOptionsBuilder","ttspinner", (Restangular,$uibModal,flash,DTOptionsBuilder,ttspinner) ->
   ctrl=@
   ctrl.dtInstance = {}
   ctrl.dtOptions = DTOptionsBuilder.newOptions().withDOM("<'row'<'col-sm-5'l><'col-sm-2'B><'col-sm-5'f>>" + "<'row'<'col-sm-12'tr>>" + "<'row'<'col-sm-5'i><'col-sm-7'p>>").withButtons [
     {
       text: "New Resource"
       className: "btn-primary"
       action: (e, dt, node, config) ->
         ctrl.add()
     }
   ]
   
   delete_from = (array,obj) ->
     index = array.indexOf(obj)
     array.splice(index,1)
   
   resources = Restangular.all('admin/resources')
   ttspinner.show()
   resources.getList()
     .then (resources) ->
       ctrl.resources = resources
     .finally ->
       ttspinner.hide()
     
   ctrl.delete = (resource) ->
      modalInstance = $uibModal.open {
        ariaLabelledBy: 'modal-title',
        ariaDescribedBy: 'modal-body',
        templateUrl: 'modals/yesNoModal.html',
        controller: 'YesNoModalCtrl',
        controllerAs: 'ctrl',
        size: "sm",
        resolve: {
          question: ->
            return "Do you want to delete the resource "+resource.protocol+" - "+resource.address
        }
      }

      modalInstance.result.then (answer) ->
        if answer=="yes"
          ttspinner.show()
          resource.remove().then ->
            flash.reportSuccess("Resource has been successfully removed!!!")
            delete_from ctrl.resources, resource
          , (result)->
            flash.reportDanger(result.data.errors)
          .finally ->
            ttspinner.hide()
   
   ctrl.add = () ->
     modalInstance = $uibModal.open {
        ariaLabelledBy: 'modal-title',
        ariaDescribedBy: 'modal-body',
        templateUrl: 'admin/resources/edit.html',
        controller: 'resourceEditCtrl',
        controllerAs: 'ctrl',
        size: null,
        resolve: {
          data: ->
            return {
              resource: {
              }
              mode: "new"
            }
        }
      }

     modalInstance.result.then (resource) ->
       ttspinner.show()
       resources.post(resource).then (response)->
         flash.reportSuccess("Resource has been successfully created!!!")
         ctrl.resources.unshift(response)
       , (result)->
         flash.reportDanger("Adding resource failed: "+result.data.errors)    
       .finally ->
         ttspinner.hide()
   
   ctrl.edit = (resource) ->
      initial_resource = angular.copy(resource)
      modalInstance = $uibModal.open {
        ariaLabelledBy: 'modal-title',
        ariaDescribedBy: 'modal-body',
        templateUrl: 'admin/resources/edit.html',
        controller: 'resourceEditCtrl',
        controllerAs: 'ctrl',
        resolve: {
          data: ->
            return {
              resource: resource
              mode: "edit"
            }
        }
      }

      modalInstance.result.then (resource) ->
          ttspinner.show()
          resource.patch().then ->
            flash.reportSuccess("Resource has been successfully updated!!!")
          , (result)->
            angular.copy(initial_resource,resource)
            flash.reportDanger("Update failed: "+result.data.errors)
          .finally ->
            ttspinner.hide()
       , (type) ->
         angular.copy(initial_resource,resource)  
   return  
]

@bearsNg.controller 'resourceEditCtrl', [ "$uibModalInstance", "data",($uibModalInstance, data) ->
  ctrl = @
  ctrl.resource = data.resource
  ctrl.mode = data.mode
  ctrl.title = data.mode.charAt(0).toUpperCase() + data.mode.slice(1)
  
  ctrl.save_disabled = ->
    ctrl.form.$invalid
      
  ctrl.save = ->
    $uibModalInstance.close(ctrl.resource)

  ctrl.cancel = ->
    $uibModalInstance.dismiss('cancel')
  
  return
]