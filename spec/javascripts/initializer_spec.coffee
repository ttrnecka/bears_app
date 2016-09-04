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
  describe 'Plotter', ->
    it 'should be initialized', ->
      expect app.utils.plotter
        .toBeDefined()
    it 'should plot pie chart', ->
      spyOn($,'plot').and.returnValue("plotObj")
      plotObj = app.utils.plotter.pie_chart($('#test'),[])
      expect(plotObj).toEqual("plotObj")
      expect($.plot.calls.argsFor(0)[2].series.pie.show).toBe(true)
  

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
    
  it 'should show table if hidden as result of turbolink:before-cache',->
    $('<div id="users_table_wrapper"><table id="users_table"></table></div>').appendTo('body')
    Turbolinks.dispatch("turbolinks:before-cache")
    expect($('#users_table')).not.toBeVisible()
    Turbolinks.dispatch("turbolinks:load")
    expect($('#users_table')).toBeVisible()
    $('#users_table_wrapper').remove()
    
  it 'should highlight correct menu section', ->
    MagicLamp.load("layouts/sidebar")
    spyOn(app.utils,'locationHref').and.returnValue('http://localhost:3000/users')
    Turbolinks.dispatch("turbolinks:load")
    expect($("a[href='/users']")).toHaveClass('active')

describe 'Turbolinks:before-cache', ->
  beforeEach ()->
    app.data_tables.users_table = {
      destroy:()->
        return
    }
    spyOn(app.data_tables.users_table,'destroy')
    
  it 'should destroy user table if it exists', ->
    $('<div id="users_table_wrapper"><table id="users_table"></table></div>').appendTo('body')
    Turbolinks.dispatch("turbolinks:before-cache")
    expect(app.data_tables.users_table.destroy).toHaveBeenCalled()
    expect($('#users_table')).not.toBeVisible()
    $('#users_table_wrapper').remove()
    
  it 'should not destroy user table if it does not exist', ->
    Turbolinks.dispatch("turbolinks:before-cache")
    expect(app.data_tables.users_table.destroy).not.toHaveBeenCalled()