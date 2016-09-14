describe 'Angular setup', ()->
  beforeEach(module('bearsApp'))
  restangular = null
  beforeEach inject (Restangular) ->
    restangular = Restangular
    return
    
  it 'configures Restangular suffix as json', ->
    expect(restangular.configuration.suffix).toEqual(".json")