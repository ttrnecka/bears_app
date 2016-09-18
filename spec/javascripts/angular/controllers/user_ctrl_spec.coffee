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
      login: "user2"
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
      $httpBackend.flush()
      return
      
    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()
      
    it "should load users data",->
      $httpBackend.expectGET("/users.json").respond(fake_users)
      ctrl = $controller 'UserCtrl', {
        $scope: $scope
        Restangular: restangular
        $uibModal: $uibModal
        flash: flash
      }
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(ctrl.users[0].name).toEqual(fake_users[0].name)
      
    it "should delete user once confirmed",->
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
        user = ctrl.users[0]
        expect(user.roles_to_s).toBeDefined()
        
      it 'roles_to_s should return admin for admin',->
        user = ctrl.users[1]
        expect(user.roles_to_s()).toEqual("admin")
      
      it 'roles_to_s should return user for user',->
        user = ctrl.users[0]
        expect(user.roles_to_s()).toEqual("user")
        
      it "should have isAdmin(), isUser() function",->
        user = ctrl.users[0]
        expect(user.isAdmin).toBeDefined()
        expect(user.isUser).toBeDefined()
        
      it 'isAdmin() should return true for admin and false otherwise',->
        user = ctrl.users[1]
        expect(user.isAdmin()).toBe(true)
        user = ctrl.users[0]
        expect(user.isAdmin()).toBe(false)
      
      it 'isUser() should return true for user and false otherwise',->
        user = ctrl.users[1]
        expect(user.isUser()).toBe(false)
        user = ctrl.users[0]
        expect(user.isUser()).toBe(true)
        
    describe "User View",->
      $compile = null
      element = null
      beforeEach inject (_$compile_, _$rootScope_,$timeout) ->
        $compile = _$compile_
        $rootScope = _$rootScope_
        viewHtml = MagicLamp.loadRaw("users/index")
        ang_element = angular.element(viewHtml)
        $httpBackend.expectGET("/users.json").respond(fake_users)
        element = $compile(ang_element)($rootScope)
        # double timeout to handle DT rendering
        $timeout.flush()
        $httpBackend.flush()
        $rootScope.$digest()
        $timeout.flush()
        
      afterEach ->
        MagicLamp.clean()
      
      it 'should have users datatable',->
        expect(element.find('#users_table[datatable="ng"]').length).toEqual(1)
        # 2 mocked users
        expect(element.find('.users_table_line').length).toEqual(2)
        
      it 'should display promote option for user role', ->
        expect(element.find('li.user_promote:eq(0)').length).toEqual(1)
        expect(element.find('li.user_promote:eq(0)').hasClass('ng-hide')).toBe(false)
      
      it 'should hide promote option for admin role', ->
        expect(element.find('li.user_promote:eq(1)').length).toEqual(1)
        expect(element.find('li.user_promote:eq(1)').hasClass('ng-hide')).toBe(true)
      
      it 'should display demote option for admin role', ->
        expect(element.find('li.user_demote:eq(1)').length).toEqual(1)
        expect(element.find('li.user_demote:eq(1)').hasClass('ng-hide')).toBe(false)
      
      it 'should hide demote option for user role', ->
        expect(element.find('li.user_demote:eq(0)').length).toEqual(1)
        expect(element.find('li.user_demote:eq(0)').hasClass('ng-hide')).toBe(true)
        
      it 'should display delete option for every users', ->
        expect(element.find('li.user_delete').length).toEqual(2)
        expect(element.find('li.user_delete').hasClass('ng-hide')).toBe(false)
      