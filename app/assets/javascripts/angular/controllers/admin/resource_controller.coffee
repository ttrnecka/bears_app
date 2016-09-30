@bearsNg.controller "Admin::ResourceCtrl", [ 'Restangular', '$uibModal', "flash", "DTOptionsBuilder","ttspinner","$filter", (Restangular,$uibModal,flash,DTOptionsBuilder,ttspinner,$filter) ->
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
   ctrl.credentials = []
   ctrl.instances = []
   
   delete_from = (array,obj) ->
     index = array.indexOf(obj)
     array.splice(index,1)
   
   loaded = {
     resources: false
     credentials: false
     instances: false
   }
   
   ctrl.all_loaded = ()->
     loaded.resources && loaded.credentials && loaded.instances
   
   resources = Restangular.all('admin/resources')
   credentials = Restangular.all('admin/credentials')
   instances = Restangular.all('bears_instances')
   
   ttspinner.show()
        
   credentials.getList()
     .then (credentials) ->
       ctrl.credentials = credentials
     .finally ->
       loaded.credentials = true
       if ctrl.all_loaded() then ttspinner.hide()
   
   instances.getList()
     .then (instances) ->
       ctrl.instances = instances
     .finally ->
       loaded.instances = true
       if ctrl.all_loaded() then ttspinner.hide()
   
   resources.getList()
     .then (resources) ->
       ctrl.resources = resources
     .finally ->
       loaded.resources = true
       if ctrl.all_loaded() then ttspinner.hide()
             
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
              credentials: ctrl.credentials
              instances: ctrl.instances
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
              credentials: ctrl.credentials
              instances: ctrl.instances
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
   
   ctrl.getCredentialById = (id) ->
     $filter('getById')(ctrl.credentials, id)
     
   ctrl.getInstanceById = (id) ->
     $filter('getById')(ctrl.instances, id)
     
   return  
]

@bearsNg.controller 'resourceEditCtrl', [ "$uibModalInstance", "data",($uibModalInstance, data) ->
  ctrl = @
  ctrl.resource = data.resource
  ctrl.credentials = data.credentials
  ctrl.instances = data.instances
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