describe 'Admin::Credential', ()->
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
  
  fake_credentials = [
    {
      id:1
      description: "acc1"
      account: "account1"
    },
    {
      id:2
      description: "acc2"
      account: "account2"
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
    credential = {
      description: "Test description"
      account: "test"
    }
  describe 'credentialCtrl', ->
    beforeEach inject (_$controller_,$rootScope,Restangular,_$uibModal_,$injector,_flash_,ttspinner)->
      $scope=$rootScope.$new();
      $httpBackend = $injector.get('$httpBackend')
      restangular = Restangular
      $uibModal = _$uibModal_
      $controller = _$controller_
      flash = _flash_
      spinner = ttspinner
      spyOn($uibModal,"open").and.returnValue(fakeModal)
      $httpBackend.expectGET("/admin/credentials.json").respond(fake_credentials)
      ctrl = $controller 'Admin::CredentialCtrl', {
        $scope: $scope
        Restangular: restangular
        $uibModal: $uibModal
        flash: flash
      }
      return
      
    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()
      
    it "should load credentials data",->
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(ctrl.credentials[0].account).toEqual(fake_credentials[0].account)
      
    it "should delete credential once confirmed",->
      $httpBackend.flush()
      # opens modal
      crd = ctrl.credentials[0]
      size = ctrl.credentials.length
      ctrl.delete(crd)
      # simulate modal cofirm
      $httpBackend.expectDELETE("/admin/credentials/"+crd.id+".json").respond(204,'')
      fakeModal.close("yes")
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual("Credential has been successfully removed!!!")
      expect(ctrl.credentials.length).toEqual(size-1)
      
    it "should not delete credential if not confirmed",->
      $httpBackend.flush()
      # opens modal
      crd = ctrl.credentials[0]
      size = ctrl.credentials.length
      ctrl.delete(crd)
      # simulate modal cofirm
      fakeModal.close("no")
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual("")
      expect(ctrl.credentials.length).toEqual(size)
      
    it "should fill flash message if delete credential cannot be done",->
      $httpBackend.flush()
      # opens modal
      crd = ctrl.credentials[0]
      ctrl.delete(crd)
      # simulate modal cofirm
      # unprocesable entity
      msg = "Credential cannot be removed"
      $httpBackend.expectDELETE("/admin/credentials/"+crd.id+".json").respond(422,{errors:[msg]})
      fakeModal.close("yes")
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual([msg])
    
    it "should restore the credential if edit was cancelled", ->
      $httpBackend.flush()
      # opens edit modal
      crd = ctrl.credentials[0]
      initial = angular.copy(crd)
      ctrl.edit(crd)
      # edit the credential
      crd.account = "changed_account"
      crd.password = "pwd"
      crd.password_confirmation = "pwd"
      fakeModal.dismiss("cancel")
      expect(spinner.state).toBe(false)
      expect(crd).toEqual(initial)
    
    it "should update credential once saved",->
      $httpBackend.flush()
      # opens edit modal
      crd = ctrl.credentials[0]
      ctrl.edit(crd)
      # edit the credential
      crd.account = "changed_account"
      crd.password = "pwd"
      crd.password_confirmation = "pwd"
      # simulate modal save
      $httpBackend.expectPATCH("/admin/credentials/"+crd.id+".json").respond(crd)
      fakeModal.close(crd)
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual("Credential has been successfully updated!!!")
      expect(crd.password).not.toBeDefined()
      expect(crd.password_confirmation).not.toBeDefined()
    
    it "should fill flash message if update credential cannot be done",->
      $httpBackend.flush()
      # opens modal
      crd = ctrl.credentials[0]
      ctrl.edit(crd)
      # edit the credential
      old_description = crd.description
      crd.description = "invalid description"
      # simulate modal cofirm
      # unprocesable entity
      msg = "Credential cannot be updated"
      $httpBackend.expectPATCH("/admin/credentials/"+crd.id+".json").respond(422,{errors:[msg]})
      fakeModal.close(crd)
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual("Update failed: " + [msg])
      expect(crd.description).toEqual(old_description)
      
    it "should fill flash message if adding credential cannot be done",->
      $httpBackend.flush()
      # opens modal
      ctrl.add()
      # fill the credential
      # simulate modal cofirm
      # unprocesable entity
      msg = "Credential cannot be created"
      $httpBackend.expectPOST("/admin/credentials.json").respond(422,{errors:[msg]})
      crd = {
        description: "new_description"
        account: "new_account"
        password: "new_password"
        password_confirmation: "new_password"
      }
      fakeModal.close(crd)
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual("Adding credential failed: " + [msg])
      
    it "should create credential once saved",->
      $httpBackend.flush()
      # opens edit modal
      ctrl.add()
      # fill the credential
      # simulate modal save
      crd = {
        description: "new_description"
        account: "new_account"
        password: "new_password"
        password_confirmation: "new_password"
      }
      $httpBackend.expectPOST("/admin/credentials.json").respond(crd)
      fakeModal.close(crd)
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual("Credential has been successfully created!!!")
      expect(ctrl.credentials[0].description).toEqual(crd.description)
      
  describe 'credentialEdit', ->
    describe 'controller', ->  
      beforeEach inject ($controller,_$templateCache_, _$compile_,$rootScope,_$timeout_,$injector)->
        $scope=$rootScope.$new();
        $timeout = _$timeout_
        $httpBackend = $injector.get('$httpBackend')
        ctrl = $controller 'credentialEditCtrl', {
          $uibModalInstance: modalInstance, 
          data: 
            credential: credential
            mode: "edit"
        }
        $templateCache = _$templateCache_
        $compile = _$compile_
    
        return
        
      it "returns changed credetial upon save", ->
        spyOn(modalInstance,'close')
        ctrl.credential.account = "changed"
        ctrl.save()
        expect(modalInstance.close.calls.argsFor(0)[0].account).toEqual("changed")
     
      it "returns dismiss modal upon cancel", ->
        spyOn(modalInstance,'dismiss')
        ctrl.cancel()
        expect(modalInstance.dismiss.calls.argsFor(0)).toEqual(["cancel"])
        
      it "should initiate credential variable", ->
        expect(ctrl.credential).toEqual(credential)
        
      it "ctrl.save_disabled() should return true if password do not match",->
        ctrl.credential.password = "1"
        ctrl.credential.password_confirmation = "2"
        expect(ctrl.save_disabled()).toBe(true)
      
      it "ctrl.password_ok() return true if passwords are same", ->
        ctrl.credential.password = "1"
        ctrl.credential.password_confirmation = "1"
        expect(ctrl.password_ok()).toBe(true)
      
      it "ctrl.password_ok() return false if passwords are not same", ->
        ctrl.credential.password = "1"
        ctrl.credential.password_confirmation = "2"
        expect(ctrl.password_ok()).toBe(false)
        
      describe "template",->
        beforeEach ->
          $scope.ctrl = ctrl
          
          modalTemplate = $templateCache.get('admin/credentials/edit.html')
          @element = $compile(modalTemplate)($scope)

        it "should contain all elements with proper values",->
          $scope.$digest()
          expect(@element.find('input[name="description"]').val()).toBe(credential.description)
          expect(@element.find('input[name="account"]').val()).toBe(credential.account)
          expect(@element.find('input[name="password"]').val()).toBe("")
          expect(@element.find('input[name="password_confirmation"]').val()).toBe("")
          expect(@element.find('button[ng-click="ctrl.save()"]').text()).toBe("Save")
          expect(@element.find('button[ng-click="ctrl.cancel()"]').text()).toBe("Cancel")
        
        it "should reflect input change in controller", ->
          $scope.$digest()
          @element.find('input[name="description"]').val("changed_desc").triggerHandler('input')
          @element.find('input[name="account"]').val("changed_acc").triggerHandler('input')
          @element.find('input[name="password"]').val("changed_pwd").triggerHandler('input')
          @element.find('input[name="password_confirmation"]').val("changed_pwd").triggerHandler('input')
          # description has debounced async handler so we need to simulate http and flush ale timeouts
          $httpBackend.expectGET("/admin/credentials/search.json?description=changed_desc").respond(200,[])
          $timeout.flush()
          $httpBackend.flush()
          expect($scope.ctrl.credential.description).toBe("changed_desc")
          expect($scope.ctrl.credential.account).toBe("changed_acc")
          expect($scope.ctrl.credential.password).toBe("changed_pwd")
          expect($scope.ctrl.credential.password_confirmation).toBe("changed_pwd")
        
        it "should have fields_wit_errors class divs if password does not match confirmation",->
          @element.find('input[name="password"]').val("changed_pwd").triggerHandler('input')
          @element.find('input[name="password_confirmation"]').val("changed_pwd_wrong").triggerHandler('input'); 
          $scope.$digest();
          expect(@element.find('div.field_with_errors').length).toEqual(2)
        
        it "should have fields_wit_errors class divs if account is missing",->
          @element.find('input[name="account"]').val("").triggerHandler('input') 
          $scope.$digest();
          expect(@element.find('div.field_with_errors').length).toEqual(1)
        
        it "should have fields_wit_errors class divs if description is invalid",->
          $scope.$digest()
          ctrl.form.description.$setValidity("descriptionasync",false)
          $scope.$digest()
          expect(@element.find('div.field_with_errors').length).toEqual(1)
          
        it "should have fields_wit_errors class divs if description is empty",->
          $scope.$digest()
          ctrl.form.description.$setValidity("required",false)
          $scope.$digest()
          expect(@element.find('div.field_with_errors').length).toEqual(1)
            
        it 'should have disabled Save button if password and password confirmation are not the same', ->
          @element.find('input[name="password"]').val("changed_pwd").triggerHandler('input')
          @element.find('input[name="password_confirmation"]').val("changed_pwd_wrong").triggerHandler('input'); 
          $scope.$digest();
          expect(@element.find('button[ng-click="ctrl.save()"]').prop('disabled')).toBe(true)
          
        it 'should have disabled Save button if form is invalid', ->
          $scope.$digest()
          ctrl.form.description.$setValidity("descriptionasyc",false)
          $scope.$digest();
          expect(@element.find('button[ng-click="ctrl.save()"]').prop('disabled')).toBe(true)

        it "should display message about checking description", ->
          $scope.$digest()
          ctrl.form.description.$setValidity("descriptionasync",undefined)
          $scope.$digest()
          expect(@element.find('li[name="desc_check_pending"]').hasClass("ng-hide")).not.toBe(true)
        
        it "should display message about wrong description", ->
          $scope.$digest()
          ctrl.form.description.$setValidity("descriptionasync",false)
          $scope.$digest()
          expect(@element.find('li[name="desc_check_error"]').hasClass("ng-hide")).not.toBe(true)
        
        it "should display message about empty description", ->
          $scope.$digest()
          ctrl.form.description.$setValidity("required",false)
          $scope.$digest()
          expect(@element.find('li[name="desc_exist_check_error"]').hasClass("ng-hide")).not.toBe(true)
        
        it "should display message about wrong password", ->
          $scope.$digest()
          @element.find('input[name="password"]').val("changed_pwd").triggerHandler('input')
          @element.find('input[name="password_confirmation"]').val("wrong_pwd").triggerHandler('input')
          $scope.$digest()
          expect(@element.find('li[name="passwd_check_error"]').hasClass("ng-hide")).not.toBe(true)
          
        it "should not display message about missing password if edit mode", ->
          $scope.$digest()
          @element.find('input[name="password"]').val("").triggerHandler('input')
          @element.find('input[name="password_confirmation"]').val("").triggerHandler('input')
          $scope.$digest()
          expect(@element.find('li[name="passwd_exist_check_error"]').hasClass("ng-hide")).toBe(true)
          
        it "should display message about missing password if not edit mode", ->
          ctrl = $controller 'credentialEditCtrl', {
            $uibModalInstance: modalInstance, 
            data: 
              credential: credential
              mode: "new"
          }
          $scope.ctrl = ctrl
          modalTemplate = $templateCache.get('admin/credentials/edit.html')
          @element = $compile(modalTemplate)($scope)
          
          $scope.$digest()
          @element.find('input[name="password"]').val("").triggerHandler('input')
          @element.find('input[name="password_confirmation"]').val("").triggerHandler('input')
          $scope.$digest()
          expect(@element.find('li[name="passwd_exist_check_error"]').hasClass("ng-hide")).not.toBe(true)
          
        it "should display message about missing account", ->
          $scope.$digest()
          @element.find('input[name="account"]').val("").triggerHandler('input')
          $scope.$digest()
          expect(@element.find('li[name="account_check_error"]').hasClass("ng-hide")).not.toBe(true)
        
        it "should display the proper title", ->
          $scope.$digest()
          expect(@element.find('h3').text()).toMatch("Edit")