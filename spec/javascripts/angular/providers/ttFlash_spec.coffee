describe 'Flash factory', ()->
  beforeEach(module('bearsApp'))
  flash = null
  $timeout = null
  beforeEach inject (_flash_,_$timeout_) ->
    flash = _flash_
    $timeout = _$timeout_
    return
    
  it 'should set/get message with success type', ->
    flash.reportSuccess("msg")
    expect(flash.getMessage()).toEqual("msg")
    expect(flash.isSuccess()).toBe(true)
    expect(flash.isInfo()).toBe(false)
    expect(flash.isWarning()).toBe(false)
    expect(flash.isDanger()).toBe(false)
  
  it 'should set/get message with info type', ->
    flash.reportInfo("msg")
    expect(flash.getMessage()).toEqual("msg")
    expect(flash.isSuccess()).toBe(false)
    expect(flash.isInfo()).toBe(true)
    expect(flash.isWarning()).toBe(false)
    expect(flash.isDanger()).toBe(false)
    
  it 'should set/get message with warning type', ->
    flash.reportWarning("msg")
    expect(flash.getMessage()).toEqual("msg")
    expect(flash.isSuccess()).toBe(false)
    expect(flash.isInfo()).toBe(false)
    expect(flash.isWarning()).toBe(true)
    expect(flash.isDanger()).toBe(false)
  
  it 'should set/get message with danger type', ->
    flash.reportDanger("msg")
    expect(flash.getMessage()).toEqual("msg")
    expect(flash.isSuccess()).toBe(false)
    expect(flash.isInfo()).toBe(false)
    expect(flash.isWarning()).toBe(false)
    expect(flash.isDanger()).toBe(true)
      
  it 'should clear the message in 10s by default',->
    flash.reportSuccess("msg")
    $timeout.flush(5000)
    expect(flash.getMessage()).toEqual("msg")
    expect(flash.isSuccess()).toBe(true)
    $timeout.flush(5000)
    $timeout.verifyNoPendingTasks()
    expect(flash.getMessage()).toEqual("")
    expect(flash.isSuccess()).toBe(false)
  
  it 'should clear the message in selected amount of seconds',->
    flash.reportSuccess("msg",20)
    $timeout.flush(5000)
    expect(flash.getMessage()).toEqual("msg")
    expect(flash.isSuccess()).toBe(true)
    expect(flash.isMessage()).toBe(true)
    $timeout.flush(5000)
    expect(flash.getMessage()).toEqual("msg")
    expect(flash.isSuccess()).toBe(true)
    expect(flash.isMessage()).toBe(true)
    $timeout.flush(10000)
    $timeout.verifyNoPendingTasks()
    expect(flash.getMessage()).toEqual("")
    expect(flash.isSuccess()).toBe(false)
    expect(flash.isMessage()).toBe(false)

describe "ttFlash directive", ->
  beforeEach(module('bearsApp'))
  $compile = null
  $rootScope = null
  flash = null
  element = null
  $timeout = null
  
  beforeEach inject (_$compile_, _$rootScope_, _flash_, _$timeout_ ) ->
    $compile = _$compile_
    $rootScope = _$rootScope_
    flash = _flash_
    $timeout = _$timeout_
    
    element = $compile("<tt-flash></tt-flash")($rootScope);
    
  it "shows success message with alert-success class",->
    flash.reportSuccess("Success message")
    $rootScope.$digest()
    expect(element.html()).toContain("Success message")
    expect(element.hasClass("alert-success")).toBe(true)
  
  it "shows info message with alert-info class",->
    flash.reportInfo("Info message")
    $rootScope.$digest()
    expect(element.html()).toContain("Info message")
    expect(element.hasClass("alert-info")).toBe(true)
     
  it "shows warning message with alert-warning class",->
    flash.reportWarning("Warning message")
    $rootScope.$digest()
    expect(element.html()).toContain("Warning message")
    expect(element.hasClass("alert-warning")).toBe(true)
  
  it "shows danger message with alert-danger class",->
    flash.reportDanger("Danger message")
    $rootScope.$digest()
    expect(element.html()).toContain("Danger message")
    expect(element.hasClass("alert-danger")).toBe(true)
    
  it "hides message after 10 seconds",->
    flash.reportInfo("Info message")
    $timeout.flush(5000)
    $rootScope.$digest()
    expect(element.html()).toContain("Info message")
    expect(element.hasClass("alert-info")).toBe(true)
    expect(element.hasClass("ng-hide")).toBe(false)
    $timeout.flush(10000)
    $timeout.verifyNoPendingTasks()
    $rootScope.$digest()
    expect(element.hasClass("ng-hide")).toBe(true)
    expect(element.html()).toEqual("")
    expect(element.hasClass("alert-info")).toBe(false)