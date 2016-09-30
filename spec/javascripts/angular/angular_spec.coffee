describe 'Angular setup', ()->
  beforeEach(module('bearsApp', ($provide) ->
    $provide.value('$window', 
      {
        location:
          href:'dummy'
        alert: ->
      }
    )
    return
  ))
  restangular = null
  $httpBackend = null
  $window = null
  flash = null
  
  beforeEach inject (Restangular,$injector,_$window_,_flash_) ->
    restangular = Restangular
    $window = _$window_
    flash = _flash_
    $httpBackend = $injector.get('$httpBackend')
       
  it 'configures Restangular suffix as json', ->
    expect(restangular.configuration.suffix).toEqual(".json")
    
  describe "Errorhandler",->
      
    it "should redirect to /sign_in if response is 401",->
      spyOn($window,"alert")
      $httpBackend.expectGET("/users.json").respond(401,'')
      restangular.all('users').getList()
      $httpBackend.flush()
      expect($window.location.href).toMatch("signin")
      expect($window.alert).toHaveBeenCalled()
      expect($window.alert.calls.argsFor(0)).toEqual(["Not logged in - redirecting to sing in page"])
    
    it "should redirect to / if response is 403",->
      spyOn($window,"alert")
      $httpBackend.expectGET("/users.json").respond(403,'')
      restangular.all('users').getList()
      $httpBackend.flush()
      expect($window.location.href).toEqual("/")
      expect($window.alert).toHaveBeenCalled()
      expect($window.alert.calls.argsFor(0)).toEqual(["Access forbidden"])
      
    it "should flash message is response is 500",->
      $httpBackend.expectGET("/users.json").respond(500,'')
      restangular.all('users').getList()
      $httpBackend.flush()
      expect(flash.getMessage()).toEqual("Internal Server Error")
      expect(flash.isDanger()).toBe(true)
      
describe "Filters", ->
  describe "getbById filter",->
  
  array = [
    {
      id:1
      name: "name1"
    }
    {
      id:2
      name: "name2"
    }
  ]
    
  beforeEach(module('bearsApp'))
  $filter = null
  
  beforeEach inject (_$filter_) ->
    $filter = _$filter_
    
  it 'returns the member of array by id property',->
    expect($filter('getById')(array,1).name).toEqual("name1")
  
  it 'returns null if member with given id does not exit',->
    expect($filter('getById')(array,3)).toEqual(null)
  
  it 'returns null if array is empty',->
    expect($filter('getById')([],3)).toEqual(null)
  