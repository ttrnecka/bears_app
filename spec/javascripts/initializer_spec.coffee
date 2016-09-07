app = window.bearsApp

describe 'Initialization', ->
  it 'should initialize utils', ->
    expect app.utils
      .toBeDefined()
    expect app.utils.locationHref
      .toBeDefined()  

describe 'Turbolinks:load', ->
  beforeEach ->
    spyOn($.fn,'metisMenu')
    spyOn($.fn,'DataTable').and.returnValue("DT");
    spyOn(angular,'bootstrap');
  
  afterEach ->
    MagicLamp.clean()
  
  it 'should initialize ng bearsApp', ->
    Turbolinks.dispatch("turbolinks:load")
    expect(angular.bootstrap.calls.argsFor(0)).toEqual([document.body, ['bearsApp']])
  
  it 'should initialize metisMenu', ->
    Turbolinks.dispatch("turbolinks:load")
    expect($.fn.metisMenu).toHaveBeenCalled()
    
  it 'should highlight correct menu section', ->
    MagicLamp.load("layouts/sidebar")
    spyOn(app.utils,'locationHref').and.returnValue('http://localhost:3000/users')
    Turbolinks.dispatch("turbolinks:load")
    expect($("a[href='/users']")).toHaveClass('active')