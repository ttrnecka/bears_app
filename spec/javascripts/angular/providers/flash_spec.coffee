describe 'Flash factory', ()->
  beforeEach(module('bearsApp'))
  flash = null
  $timeout = null
  beforeEach inject (_flash_,_$timeout_) ->
    flash = _flash_
    $timeout = _$timeout_
    return
    
  it 'should set/get message with success type', ->
    flash.setMessage("msg","Success")
    expect(flash.getMessage()).toEqual("msg")
    expect(flash.show()).toEqual("Success")
  
  it 'should set/get message with error type', ->
    flash.setMessage("msg","Error")
    expect(flash.getMessage()).toEqual("msg")
    expect(flash.show()).toEqual("Error")
  
  it 'should set/get message with info type', ->
    flash.setMessage("msg","Info")
    expect(flash.getMessage()).toEqual("msg")
    expect(flash.show()).toEqual("Info")
      
  it 'should ignore any other type', ->
    flash.setMessage("msg","XXX")
    expect(flash.getMessage()).toEqual("msg")
    expect(flash.show()).toEqual("")
    
  it 'should clear the message in 10s by default',->
    flash.setMessage("msg","Info")
    $timeout.flush(5000)
    expect(flash.getMessage()).toEqual("msg")
    expect(flash.show()).toEqual("Info")
    $timeout.flush(5000)
    $timeout.verifyNoPendingTasks()
    expect(flash.getMessage()).toEqual("")
    expect(flash.show()).toEqual("")
  
  it 'should clear the message in selected amount of seconds',->
    flash.setTimeout(20)
    flash.setMessage("msg","Info")
    $timeout.flush(5000)
    expect(flash.getMessage()).toEqual("msg")
    expect(flash.show()).toEqual("Info")
    $timeout.flush(5000)
    expect(flash.getMessage()).toEqual("msg")
    expect(flash.show()).toEqual("Info")
    $timeout.flush(10000)
    $timeout.verifyNoPendingTasks()
    expect(flash.getMessage()).toEqual("")
    expect(flash.show()).toEqual("")
    
    
    