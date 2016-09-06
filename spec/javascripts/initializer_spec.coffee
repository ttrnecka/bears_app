#= require initializers
app = window.bearsApp

describe 'Initialization', ->
  it 'should initialize data table variable', ->
    expect app.data_tables
      .toBeDefined()
    expect app.data_tables.users_table
      .toBeDefined()
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
    
  it 'should initialize user table', ->
    $('<table id="users_table"></table>').appendTo('body')
    Turbolinks.dispatch("turbolinks:load")
    expect($.fn.DataTable).toHaveBeenCalled()
    expect(app.data_tables.users_table).toEqual("DT")
    $('#users_table').remove()
    
  it 'should highlight correct menu section', ->
    MagicLamp.load("layouts/sidebar")
    spyOn(app.utils,'locationHref').and.returnValue('http://localhost:3000/users')
    Turbolinks.dispatch("turbolinks:load")
    expect($("a[href='/users']")).toHaveClass('active')
  
  it 'should show the users_table element if ti was hidden',->
    MagicLamp.load("users/index")
    $('#users_table').DataTable();
    $('#users_table').hide();
    expect($('#users_table')).not.toBeVisible()
    Turbolinks.dispatch("turbolinks:load")
    expect($('#users_table')).toBeVisible()

describe 'Turbolinks:before-cache', ->
  beforeEach ()->
    app.data_tables.users_table = {
      destroy:()->
        return
    }
    spyOn(angular,'bootstrap');
    spyOn(app.data_tables.users_table,'destroy').and.callThrough
  
  afterEach ->
    MagicLamp.clean()
      
  it 'should destroy user table if it exists', ->
    MagicLamp.load("users/index")
    $('#users_table').DataTable();
    Turbolinks.dispatch("turbolinks:before-cache")
    expect(app.data_tables.users_table.destroy).toHaveBeenCalled()
    
  it 'should not destroy user table if it does not exist', ->
    Turbolinks.dispatch("turbolinks:before-cache")
    expect(app.data_tables.users_table.destroy).not.toHaveBeenCalled()
  
  it 'should hide the users_table element',->
    MagicLamp.load("users/index")
    $('#users_table').DataTable();
    Turbolinks.dispatch("turbolinks:before-cache")
    expect($('#users_table')).not.toBeVisible()
