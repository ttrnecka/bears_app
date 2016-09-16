describe 'Spinner factory', ()->
  beforeEach(module('bearsApp'))
  flash = null
  $timeout = null
  spinner = null
  beforeEach inject (ttspinner) ->
    spinner = ttspinner
    return
    
  it 'should open/close the modal to accordingly', ->
    spinner.show()
    expect(spinner.state).toBe(true)
    spinner.hide()
    expect(spinner.state).toBe(false)