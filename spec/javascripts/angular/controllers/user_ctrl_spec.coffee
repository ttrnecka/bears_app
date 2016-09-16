describe 'User', ()->
  beforeEach(module('bearsApp'))

  ctrl = null
  modalInstance = { 
    close: ->
    dismiss:->
  }
  $templateCache = null
  $compile = null
  $scope = null
  credential = null
  $httpBackend = null
  $uibModal = null
  $controller = null
  $scope = null
  restangular = null
  flash = null
  $timeout = null
  spinner = null
  
  fake_users = [
    {
      id:1
      name: "user1"
      login: "user"
      email: "user@user.com"
      roles: "U"
    },
    {
      id:2
      name: "user2"
      login: "second_user"
      email: "user2@user.com"
      roles: "A"
    }
  ]
  
  fakeModal = {
    result:
      then: (confirmCallback, cancelCallback) ->
        @confirmCallBack = confirmCallback;
        @cancelCallback = cancelCallback;
    close: ( item ) ->
      @result.confirmCallBack( item )
    dismiss: ( type ) ->
      @result.cancelCallback( type )
  }
  
  beforeEach ->
    user = {
      name: "test_user"
      login: "test__user"
      email: "test_user@user.com"
      roles: "U"
    }
  describe 'userCtrl', ->
    beforeEach inject (_$controller_,$rootScope,Restangular,_$uibModal_,$injector,_flash_,ttspinner)->
      $scope=$rootScope.$new();
      $httpBackend = $injector.get('$httpBackend')
      restangular = Restangular
      $uibModal = _$uibModal_
      $controller = _$controller_
      flash = _flash_
      spinner = ttspinner
      spyOn($uibModal,"open").and.returnValue(fakeModal)
      $httpBackend.expectGET("/users.json").respond(fake_users)
      ctrl = $controller 'UserCtrl', {
        $scope: $scope
        Restangular: restangular
        $uibModal: $uibModal
        flash: flash
      }
      return
      
    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()
      
    it "should load users data",->
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(ctrl.users[0].name).toEqual(fake_users[0].name)
      
    it "should delete user once confirmed",->
      $httpBackend.flush()
      # opens modal
      usr = ctrl.users[0]
      size = ctrl.users.length
      ctrl.delete(usr)
      # simulate modal cofirm
      $httpBackend.expectDELETE("/users/"+usr.id+".json").respond(204,'')
      fakeModal.close("yes")
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual("User has been successfully removed!!!")
      expect(ctrl.users.length).toEqual(size-1)
      
    it "should not delete user if not confirmed",->
      $httpBackend.flush()
      # opens modal
      usr = ctrl.users[0]
      size = ctrl.users.length
      ctrl.delete(usr)
      # simulate modal cofirm
      fakeModal.close("no")
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual("")
      expect(ctrl.users.length).toEqual(size)
      
    it "should fill flash message if delete user cannot be done",->
      $httpBackend.flush()
      # opens modal
      usr = ctrl.users[0]
      ctrl.delete(usr)
      # simulate modal cofirm
      # unprocesable entity
      msg = "User cannot be removed"
      $httpBackend.expectDELETE("/users/"+usr.id+".json").respond(422,{errors:[msg]})
      fakeModal.close("yes")
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual([msg])
      
    it "should promote user",->
      $httpBackend.flush()
      usr = ctrl.users[0]
      $httpBackend.expectPATCH("/users/"+usr.id+".json", (postdata) ->
        jsondata = JSON.parse(postdata)
        expect(jsondata.roles).toEqual("A")
        return true
      ).respond(usr)
      ctrl.promote(usr)
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual("User has been successfully promoted!!!")
      expect(ctrl.users[0].roles).toEqual("A")
      
    it "should demote user",->
      $httpBackend.flush()
      usr = ctrl.users[0]
      $httpBackend.expectPATCH("/users/"+usr.id+".json", (postdata) ->
        jsondata = JSON.parse(postdata)
        expect(jsondata.roles).toEqual("U")
        return true
      ).respond(usr)
      ctrl.demote(usr)
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual("User has been successfully demoted!!!")
      expect(ctrl.users[0].roles).toEqual("U")
      
    describe "Restangular User", ->
      
      it "should have roles_to_s() function",->
        $httpBackend.flush()
        user = ctrl.users[0]
        expect(user.roles_to_s).toBeDefined()
        
      it 'roles_to_s should return admin for admin',->
        $httpBackend.flush()
        user = ctrl.users[1]
        expect(user.roles_to_s()).toEqual("admin")
      
      it 'roles_to_s should return user for user',->
        $httpBackend.flush()
        user = ctrl.users[0]
        expect(user.roles_to_s()).toEqual("user")
        
      it "should have isAdmin(), isUser() function",->
        $httpBackend.flush()
        user = ctrl.users[0]
        expect(user.isAdmin).toBeDefined()
        expect(user.isUser).toBeDefined()
        
      it 'isAdmin() should return true for admin and false otherwise',->
        $httpBackend.flush()
        user = ctrl.users[1]
        expect(user.isAdmin()).toBe(true)
        user = ctrl.users[0]
        expect(user.isAdmin()).toBe(false)
      
      it 'isUser() should return true for user and false otherwise',->
        $httpBackend.flush()
        user = ctrl.users[1]
        expect(user.isUser()).toBe(false)
        user = ctrl.users[0]
        expect(user.isUser()).toBe(true)