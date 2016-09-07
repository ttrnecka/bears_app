describe 'Plotter', ->
  it 'should be initialized', ->
    expect window.FlotPlotter
      .toBeDefined()
  describe "Pie Chart", ->
    beforeEach ->
      $('<div id="test" style="width:100px; height:100px"></div>').appendTo('body')
      
    afterEach ->
        $('#test').remove()
        
    it 'should plot pie chart', ->
      plotObj = window.FlotPlotter.pie_chart($('#test'),[0])
      expect(plotObj.getCanvas).toBeDefined()
      options = plotObj.getOptions()
      expect(options.series.pie.show).toBe(true)
      
    it 'should be hoverable by default', ->
      plotObj = window.FlotPlotter.pie_chart($('#test'),[0])
      options = plotObj.getOptions()
      expect(options.grid.hoverable).toBe(true)

    it 'should override default options', ->
      custom_options = {
        grid:
          hoverable: false
      }
      plotObj = window.FlotPlotter.pie_chart($('#test'),[0],custom_options)
      options = plotObj.getOptions()
      expect(options.grid.hoverable).toBe(false)
      
  describe "Stack Chart", ->
    beforeEach ->
      $('<div id="test" style="width:100px; height:100px"></div>').appendTo('body')
      
    afterEach ->
        $('#test').remove()
        
    it 'should plot stack chart', ->
      plotObj = window.FlotPlotter.stack_chart($('#test'),[0])
      expect(plotObj.getCanvas).toBeDefined()
      options = plotObj.getOptions()
      expect(options.series.stack).toBe(true)
      
    it 'should be hoverable by default', ->
      plotObj = window.FlotPlotter.stack_chart($('#test'),[0])
      options = plotObj.getOptions()
      expect(options.grid.hoverable).toBe(true)

    it 'should override default options', ->
      custom_options = {
        grid:
          hoverable: false
      }
      plotObj = window.FlotPlotter.stack_chart($('#test'),[0],custom_options)
      options = plotObj.getOptions()
      expect(options.grid.hoverable).toBe(false)

