describe 'bearsDataTableService', ()->
  bearsDataTablesService = null

  beforeEach ->
    module 'bearsApp'
    inject (_bearsDataTablesService_)->
      bearsDataTablesService = _bearsDataTablesService_
      return

  beforeEach -> 
    MagicLamp.load("users/index")
  
  afterEach -> 
    MagicLamp.clean()
      
  describe 'create', ->
    it 'creates data table', ->
      dt = bearsDataTablesService.create 'users_table'
      expect dt.destroy
        .toBeDefined()
    it 'calls show method on selector', ->
      $('#users_table').hide();
      expect($('#users_table')).not.toBeVisible()
      bearsDataTablesService.create 'users_table'
      expect($('#users_table')).toBeVisible()
  
  describe 'Turbolinks:before-cache', ->
    beforeEach ->
      @dt = bearsDataTablesService.create 'users_table'
    it 'destroys existing table', ->
      spyOn(@dt,'destroy')
      Turbolinks.dispatch("turbolinks:before-cache")
      expect(@dt.destroy).toHaveBeenCalled()
    it 'hides the table element', ->
      expect($('#users_table')).toBeVisible()
      Turbolinks.dispatch("turbolinks:before-cache")
      expect($('#users_table')).not.toBeVisible()