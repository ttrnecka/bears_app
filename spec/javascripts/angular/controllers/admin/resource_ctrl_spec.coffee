describe 'Admin::Resource', ()->
  beforeEach(module('bearsApp'))

  ctrl = null
  modalInstance = { 
    close: ->
    dismiss:->
  }
  $templateCache = null
  $compile = null
  $scope = null
  resource = null
  $httpBackend = null
  $uibModal = null
  $controller = null
  $scope = null
  restangular = null
  flash = null
  $timeout = null
  spinner = null
  
  fake_resources = [
    {
      id:1
      address: "127.0.0.1"
      protocol: "http"
      credential_id: '1'
      bears_instance_id: '1'
    },
    {
      id:2
      address: "test.hp.com"
      protocol: "ssh"
      credential_id: '2'
      bears_instance_id: '2'
    },
  ]
  
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
  
  fake_instances = [
    {
      id:1
      name: "VPC UK Instance"
      comment: "VPC UK Instance"
    },
    {
      id:2
      name: "VPC Germany Instance"
      comment: "VPC Germany Instance"
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
    resource = {
      id: '100'
      address: "test.hp.com"
      protocol: "ssh"
      credential_id: 100
      bears_instance_id: 100
    }
  describe 'resourceCtrl', ->
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
      $httpBackend.expectGET("/bears_instances.json").respond(fake_instances)
      $httpBackend.expectGET("/admin/resources.json").respond(fake_resources)
      ctrl = $controller 'Admin::ResourceCtrl', {
        $scope: $scope
        Restangular: restangular
        $uibModal: $uibModal
        flash: flash
      }
      return
      
    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()
      
    it "should load all data",->
      expect(spinner.state).toBe(true)
      expect(ctrl.credentials).toEqual([])
      expect(ctrl.instances).toEqual([])
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(ctrl.resources[0].address).toEqual(fake_resources[0].address)
      expect(ctrl.credentials[0].description).toEqual(fake_credentials[0].description)
      expect(ctrl.instances[0].name).toEqual(fake_instances[0].name)
      
    it "should delete resource once confirmed",->
      $httpBackend.flush()
      # opens modal
      res = ctrl.resources[0]
      size = ctrl.resources.length
      ctrl.delete(res)
      # simulate modal cofirm
      $httpBackend.expectDELETE("/admin/resources/"+res.id+".json").respond(204,'')
      fakeModal.close("yes")
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual("Resource has been successfully removed!!!")
      expect(ctrl.resources.length).toEqual(size-1)
      
    it "should not delete resource if not confirmed",->
      $httpBackend.flush()
      # opens modal
      res = ctrl.resources[0]
      size = ctrl.resources.length
      ctrl.delete(res)
      # simulate modal cofirm
      fakeModal.close("no")
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual("")
      expect(ctrl.resources.length).toEqual(size)
      
    it "should fill flash message if delete resource cannot be done",->
      $httpBackend.flush()
      # opens modal
      res = ctrl.resources[0]
      ctrl.delete(res)
      # simulate modal cofirm
      # unprocesable entity
      msg = "Resource cannot be removed"
      $httpBackend.expectDELETE("/admin/resources/"+res.id+".json").respond(422,{errors:[msg]})
      fakeModal.close("yes")
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual([msg])
    
    it "should restore the resource if edit was cancelled", ->
      $httpBackend.flush()
      # opens edit modal
      res = ctrl.resources[0]
      initial = angular.copy(res)
      ctrl.edit(res)
      # edit the resource
      res.address = "127.0.0.1"
      fakeModal.dismiss("cancel")
      expect(spinner.state).toBe(false)
      expect(res).toEqual(initial)
    
    it "should update resource once saved",->
      $httpBackend.flush()
      # opens edit modal
      res = ctrl.resources[0]
      ctrl.edit(res)
      # edit the resource
      res.address = "127.0.0.1"
      # simulate modal save
      $httpBackend.expectPATCH("/admin/resources/"+res.id+".json").respond(res)
      fakeModal.close(res)
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual("Resource has been successfully updated!!!")
      expect(ctrl.resources[0]).toEqual(res)
      
    it "should fill flash message if update resource cannot be done",->
      $httpBackend.flush()
      # opens modal
      res = ctrl.resources[0]
      ctrl.edit(res)
      # edit the resource
      old_address = res.address
      res.address = "invalid address"
      # simulate modal cofirm
      # unprocesable entity
      msg = "Resource cannot be updated"
      $httpBackend.expectPATCH("/admin/resources/"+res.id+".json").respond(422,{errors:[msg]})
      fakeModal.close(res)
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual("Update failed: " + [msg])
      expect(res.address).toEqual(old_address)
      
    it "should fill flash message if adding resource cannot be done",->
      $httpBackend.flush()
      # opens modal
      ctrl.add()
      # fill the resource
      # simulate modal cofirm
      # unprocesable entity
      msg = "Resource cannot be created"
      $httpBackend.expectPOST("/admin/resources.json").respond(422,{errors:[msg]})
      res = {
        address: "127.0.0.2"
        protocol: "ssh"
        bears_instance_id: null
        credential_id: 1
      }
      fakeModal.close(res)
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual("Adding resource failed: " + [msg])
      
    it "should create resource once saved",->
      $httpBackend.flush()
      # opens edit modal
      ctrl.add()
      # fill the resource
      # simulate modal save
      res = {
        address: "127.0.0.2"
        protocol: "ssh"
        bears_instance_id: null
        credential_id: 1
      }
      $httpBackend.expectPOST("/admin/resources.json").respond(res)
      fakeModal.close(res)
      expect(spinner.state).toBe(true)
      $httpBackend.flush()
      expect(spinner.state).toBe(false)
      expect(flash.getMessage()).toEqual("Resource has been successfully created!!!")
      expect(ctrl.resources[0].address).toEqual(res.address)
      
  describe 'resourceEdit', ->
    describe 'controller', ->
      credentials = null
      instances = null
      beforeEach ->
        credentials = [
          {
            id:100
            description: "acc1"
            account: "account1"
          },
          {
            id:1
            description: "acc2"
            account: "account2"
          }
        ]
        instances = [
          {
            id:100
            name: "VPC UK Instance"
            comment: "VPC UK Instance"
          },
          {
            id:1
            name: "VPC NLR Instance"
            comment: "VPC NLR Instance"
          }
        ]
        return
      beforeEach inject ($controller,_$templateCache_, _$compile_,$rootScope,_$timeout_,$injector)->
        $scope=$rootScope.$new();
        $timeout = _$timeout_
        $httpBackend = $injector.get('$httpBackend')
        ctrl = $controller 'resourceEditCtrl', {
          $uibModalInstance: modalInstance, 
          data: 
            resource: resource
            credentials: credentials
            instances: instances
            mode: "edit"
        }
        $templateCache = _$templateCache_
        $compile = _$compile_
    
        return
        
      it "returns changed resource upon save", ->
        spyOn(modalInstance,'close')
        ctrl.resource.address = "changed"
        ctrl.save()
        expect(modalInstance.close.calls.argsFor(0)[0].address).toEqual("changed")
     
      it "returns dismiss modal upon cancel", ->
        spyOn(modalInstance,'dismiss')
        ctrl.cancel()
        expect(modalInstance.dismiss.calls.argsFor(0)).toEqual(["cancel"])
        
      it "should initiate resource variable", ->
        expect(ctrl.resource).toEqual(resource)
        
      it "should initiate credentials variable", ->
        expect(ctrl.credentials).toEqual(credentials)
        
      it "should initiate instances variable", ->
        expect(ctrl.instances).toEqual(instances)
          
      describe "template",->
        beforeEach ->
          $scope.ctrl = ctrl
          
          modalTemplate = $templateCache.get('admin/resources/edit.html')
          @element = $compile(modalTemplate)($scope)

        it "should contain all elements with proper values",->
          $scope.$digest()
          expect(@element.find('input[name="address"]').val()).toBe(resource.address)
          expect(@element.find('input[name="protocol"]').val()).toBe(resource.protocol)
          expect(@element.find('select[name="credential_id"]').val()).toBe('number:'+resource.credential_id)
          expect(@element.find('select[name="bears_instance_id"]').val()).toBe('number:'+resource.bears_instance_id)
          expect(@element.find('button[ng-click="ctrl.save()"]').text()).toBe("Save")
          expect(@element.find('button[ng-click="ctrl.cancel()"]').text()).toBe("Cancel")
        
        it "should reflect input change in controller", ->
          $scope.$digest()
          @element.find('input[name="address"]').val("changed_address").triggerHandler('input')
          @element.find('input[name="protocol"]').val("changed_prot").triggerHandler('input')
          @element.find('select[name="credential_id"]').val("number:"+credentials[1].id).change()
          @element.find('select[name="bears_instance_id"]').val("number:"+instances[1].id).change()
          expect($scope.ctrl.resource.address).toBe("changed_address")
          expect($scope.ctrl.resource.protocol).toBe("changed_prot")
          expect($scope.ctrl.resource.credential_id).toBe(1)
          expect($scope.ctrl.resource.bears_instance_id).toBe(1)
        
        it "should have fields_wit_errors class divs if address is missing",->
          @element.find('input[name="address"]').val("").triggerHandler('input') 
          $scope.$digest();
          expect(@element.find('div.field_with_errors').length).toEqual(1)
        
        it "should have fields_with_errors class divs if protocol is missing",->
          @element.find('input[name="protocol"]').val("").triggerHandler('input') 
          $scope.$digest();
          expect(@element.find('div.field_with_errors').length).toEqual(1)
        
        it "should have fields_with_errors class divs if credential is missing",->
          @element.find('select[name="credential_id"]').val(null).change() 
          $scope.$digest();
          expect(@element.find('div.field_with_errors').length).toEqual(1)
        
        it "should have fields_with_errors class divs if instance is missing",->
          @element.find('select[name="bears_instance_id"]').val(null).change() 
          $scope.$digest();
          expect(@element.find('div.field_with_errors').length).toEqual(1)
          
        it 'should have disabled Save button if form is invalid', ->
          $scope.$digest()
          @element.find('select[name="bears_instance_id"]').val(null).change()
          $scope.$digest();
          expect(@element.find('button[ng-click="ctrl.save()"]').prop('disabled')).toBe(true)

        it "should display message about missing address", ->
          $scope.$digest()
          @element.find('input[name="address"]').val("").triggerHandler('input')
          $scope.$digest()
          expect(@element.find('li[name="addr_exist_check_error"]').hasClass("ng-hide")).not.toBe(true)
          
        it "should display message about missing protocol", ->
          $scope.$digest()
          @element.find('input[name="protocol"]').val("").triggerHandler('input')
          $scope.$digest()
          expect(@element.find('li[name="prot_exist_check_error"]').hasClass("ng-hide")).not.toBe(true)
        
        it "should display message about missing credential", ->
          $scope.$digest()
          @element.find('select[name="credential_id"]').val(null).change()
          $scope.$digest()
          expect(@element.find('li[name="cred_exist_check_error"]').hasClass("ng-hide")).not.toBe(true)
          
        it "should display message about missing instance", ->
          $scope.$digest()
          @element.find('select[name="bears_instance_id"]').val(null).change()
          $scope.$digest()
          expect(@element.find('li[name="bi_exist_check_error"]').hasClass("ng-hide")).not.toBe(true)
          
        it "should display the proper title", ->
          $scope.$digest()
          expect(@element.find('h3').text()).toMatch("Edit")
  
  describe "Admin::Resources View",->
      $compile = null
      element = null
      httpBackend = null
      $uibModal = null
      $timeout = null
      $scope = null
      beforeEach inject (_$compile_, _$rootScope_,$injector, _$uibModal_,_$timeout_) ->
        $compile = _$compile_
        $scope = _$rootScope_.$new()
        $scope.ctrl = null
        $uibModal = _$uibModal_
        $timeout=_$timeout_
        $httpBackend = $injector.get('$httpBackend')
        spyOn($uibModal,"open").and.returnValue(fakeModal)
        viewHtml = MagicLamp.loadRaw("admin/resources/index")
        ang_element = angular.element(viewHtml)
        $httpBackend.expectGET("/admin/credentials.json").respond(fake_credentials)
        $httpBackend.expectGET("/bears_instances.json").respond(fake_instances)
        $httpBackend.expectGET("/admin/resources.json").respond(fake_resources)
        element = $compile(ang_element)($scope)
        # double timeout to handle DT rendering
        $timeout.flush()
        $httpBackend.flush()
        $scope.$digest()
        $timeout.flush()
        
      afterEach ->
        MagicLamp.clean()
      
      it 'should have resources datatable',->
        expect(element.find('#resources_table[datatable="ng"]').length).toEqual(1)
        # 2 mocked resources
        expect(element.find('.resources_table_line').length).toEqual(2)
        
      it 'should display edit option for each resource', ->
        expect(element.find('a[ng-click="ctrl.edit(resource)"]').length).toEqual(2)
        expect(element.find('a[ng-click="ctrl.edit(resource)"]').hasClass('ng-hide')).toBe(false)
        
      it 'should display delete option for each resource', ->
        expect(element.find('a[ng-click="ctrl.delete(resource)"]').length).toEqual(2)
        expect(element.find('a[ng-click="ctrl.delete(resource)"]').hasClass('ng-hide')).toBe(false)
     
      it 'should display New Resource button and call ctrl add when clicked', ->
        spyOn(element.scope().ctrl,'add')
        el = element.find('.dt-buttons > a:first')
        expect(el.text()).toEqual("New Resource")
        el.trigger('click')
        expect(element.scope().ctrl.add).toHaveBeenCalled()
        
      it 'shoud display proper credential and bears instance for resource', ->
        el = element.find('td:contains('+fake_credentials[0].description+')')
        expect(el.length).toEqual(1)
        el = element.find('td:contains('+fake_instances[0].name+')')
        expect(el.length).toEqual(1)