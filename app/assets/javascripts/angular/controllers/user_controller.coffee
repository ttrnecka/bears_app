@bearsNg.controller "UserCtrl", [ 'Restangular', '$uibModal', "flash", "DTOptionsBuilder","ttspinner", (Restangular,$uibModal,flash,DTOptionsBuilder,ttspinner) ->
   ctrl=@
   ctrl.dtInstance = {}
   ctrl.animationsEnabled = true
   Restangular.extendModel 'users', (model) ->
     model.roles_to_s = ->
       str = if model.roles=="A" then "admin" else "user"
     model.isAdmin = ->
       model.roles == "A"
     model.isUser = ->
       model.roles == "U"
     return model
  
   
   delete_from = (array,obj) ->
     index = array.indexOf(obj)
     array.splice(index,1)
   
   users = Restangular.all('users')
   ttspinner.show()
   users.getList()
     .then (users) ->
       ttspinner.hide()
       ctrl.users = users
   
   ctrl.promote = (user) ->
     init_roles = user.roles
     user.roles = "A"
     user.patch().then ->
       flash.reportSuccess("User has been successfully promoted!!!")
     , (result)->
       user.roles=init_roles
       flash.reportDanger("Update failed: "+result.data.errors)
   
   ctrl.demote = (user) ->
     init_roles = user.roles
     user.roles = "U"
     user.patch().then ->
       flash.reportSuccess("User has been successfully demoted!!!")
     , (result)->
       user.roles=init_roles
       flash.reportDanger("Update failed: "+result.data.errors)
             
   ctrl.delete = (user) ->
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
            return "Do you want to delete the user "+user.login
        }
      }

      modalInstance.result.then (answer) ->
        if answer=="yes"
          user.remove().then ->
            flash.reportSuccess("User has been successfully removed!!!")
            delete_from ctrl.users, user
          , (result)->
            flash.reportDanger(result.data.errors)
     
   return  
]