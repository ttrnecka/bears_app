describe 'Modals', ()->
  beforeEach(module('bearsApp'))

  ctrl = null
  modalInstance = { 
    close: ->
    dismiss:->
  }
  $templateCache = null
  $compile = null
  $scope = null
  
  describe 'YesNoModalCtrl', ->  
    question="Do you want to click yes"

    beforeEach inject ($controller,_$templateCache_, _$compile_,$rootScope)->
      $scope=$rootScope.$new();
      ctrl = $controller 'YesNoModalCtrl', {
        $uibModalInstance: modalInstance, 
        question: question
      }
      $templateCache = _$templateCache_
      $compile = _$compile_
    
      return
    
    it "should close modal with message yes", ->
      spyOn(modalInstance,'close')
      ctrl.yes()
      expect(modalInstance.close.calls.argsFor(0)).toEqual(["yes"])
    
    it "should close modal with message no", ->
      spyOn(modalInstance,'close')
      ctrl.no()
      expect(modalInstance.close.calls.argsFor(0)).toEqual(["no"])
    
    it "should initiate question", ->
      expect(ctrl.question).toEqual(question)
      
    it "should test the template",->
      $scope.ctrl = {
        question: question
      }
      
      modalTemplate = $templateCache.get('modals/yesNoModal.html')
      element = $compile(modalTemplate)($scope)
      $scope.$digest()
      expect(element.find('#yes_no_question').text()).toBe(question+"?")
      expect(element.find('button[ng-click="ctrl.yes()"]').text()).toBe("Yes")
      expect(element.find('button[ng-click="ctrl.no()"]').text()).toBe("No")