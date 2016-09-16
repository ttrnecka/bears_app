describe 'Spinner factory', ()->
  beforeEach(module('bearsApp'))
  flash = null
  $timeout = null
  spinner = null
  beforeEach inject (ttspinner) ->
    spinner = ttspinner
    return
    
  it 'should set the state to accordingly', ->
    spinner.show()
    expect(spinner.state).toBe(true)
    spinner.hide()
    expect(spinner.state).toBe(false)

describe "ttSpinner directive", ->
  beforeEach(module('bearsApp'))
  $compile = null
  $scope = null
  spinner = null
  element = null
  
  beforeEach inject (_$compile_, $rootScope, ttspinner) ->
    $compile = _$compile_
    spinner = ttspinner
    $scope = $rootScope.$new()
    
    element = $compile("<tt-spinner />")($scope)
    
  it "should open and close the modal",->
    $scope.$digest()
    spyOn(element,"modal")
    spinner.show()
    $scope.$digest()
    console.log element
    expect(element.modal).toHaveBeenCalled()