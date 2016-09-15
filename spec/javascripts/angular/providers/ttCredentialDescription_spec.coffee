describe "ttCredentialDescription directive", ->
  beforeEach(module('bearsApp'))
  $compile = null
  $scope = null
  element = null
  $timeout = null
  $httpBackend = null
  
  beforeEach inject (_$compile_, $rootScope, _$timeout_, $injector ) ->
    $compile = _$compile_
    $scope = $rootScope.$new()
    $timeout = _$timeout_
    $httpBackend = $injector.get('$httpBackend')
    
  it "should not query backend during initialization",->
    element = $compile("<form name=\"form\"><input name=\"test\" ng-model=\"test\" tt-credential-description /></form>")($scope);
    $scope.$digest()
    $httpBackend.verifyNoOutstandingRequest()
    
  it "should query backend and set error when found", ->
    element = $compile("<form name=\"form\"><input name=\"test\" ng-model=\"test\" tt-credential-description /></form>")($scope);
    $scope.$digest()
    $httpBackend.expectGET("/admin/credentials/search.json?description=changed").respond([{id:1, description: "changed"}])
    element.find('input').val("changed").triggerHandler('input')
    $httpBackend.flush()
    expect($scope.form.test.$error.descriptionasync).toBe(true)
    
  it "should query backend and do not set error whant not found", ->
    element = $compile("<form name=\"form\"><input name=\"test\" ng-model=\"test\" tt-credential-description /></form>")($scope);
    $scope.$digest()
    $httpBackend.expectGET("/admin/credentials/search.json?description=changed").respond([])
    element.find('input').val("changed").triggerHandler('input')
    $httpBackend.flush()
    expect($scope.form.test.$error.descriptionasync).toBe(undefined)

  it "should query backend when set to initial value", ->
    $scope.test = "init_value"
    element = $compile("<form name=\"form\"><input name=\"test\" ng-model=\"test\" tt-credential-description /></form>")($scope);
    $scope.$digest()
    
    # change
    $httpBackend.expectGET("/admin/credentials/search.json?description=changed").respond([])
    element.find('input').val("changed").triggerHandler('input')
    $httpBackend.flush()

    # change back
    element.find('input').val("init_value").triggerHandler('input')
    $httpBackend.verifyNoOutstandingRequest()
  
  