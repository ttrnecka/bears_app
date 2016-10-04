describe "ttIpOrFqdn directive", ->
  beforeEach(module('bearsApp'))
  $compile = null
  $scope = null
  element = null
  
  beforeEach inject (_$compile_, $rootScope ) ->
    $compile = _$compile_
    $scope = $rootScope.$new()
      
  it "should return false if not IP or FQDN", ->
    element = $compile("<form name=\"form\"><input name=\"test\" ng-model=\"test\" tt-ip-or-fqdn /></form>")($scope);
    $scope.$digest()
    element.find('input').val("%%").triggerHandler('input')
    $scope.$digest()
    expect($scope.form.test.$error.ip_or_fqdn).toBe(true)  
    element.find('input').val("400.400.200.100").triggerHandler('input')
    $scope.$digest()
    expect($scope.form.test.$error.ip_or_fqdn).toBe(true)
    
  it "should return true if IP", ->
    element = $compile("<form name=\"form\"><input name=\"test\" ng-model=\"test\" tt-ip-or-fqdn /></form>")($scope);
    $scope.$digest()
    element.find('input').val("127.0.1.25").triggerHandler('input')
    $scope.$digest()
    expect($scope.form.test.$error.ip_or_fqdn).not.toBeDefined()  
  
  it "should return true if FQDN", ->
    element = $compile("<form name=\"form\"><input name=\"test\" ng-model=\"test\" tt-ip-or-fqdn /></form>")($scope);
    $scope.$digest()
    element.find('input').val("test2.hpe.com").triggerHandler('input')
    $scope.$digest()
    expect($scope.form.test.$error.ip_or_fqdn).not.toBeDefined()
  
  it "should return false if just hostname", ->
    element = $compile("<form name=\"form\"><input name=\"test\" ng-model=\"test\" tt-ip-or-fqdn /></form>")($scope);
    $scope.$digest()
    element.find('input').val("test-hostname").triggerHandler('input')
    $scope.$digest()
    expect($scope.form.test.$error.ip_or_fqdn).toBe(true)