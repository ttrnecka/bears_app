describe 'HomePageCtrl', ()->
  beforeEach(module('bearsApp'))

  $controller = null
  $window = null
  plotter = null

  beforeEach inject (_$controller_,_$window_)->
    $controller = _$controller_;
    $window = _$window_;
    plotter = $window.FlotPlotter
    
    spyOn(plotter,'pie_chart').and.returnValue({obj:true})
    spyOn(plotter,'stack_chart').and.returnValue({obj:true})
    return
    
  describe 'ctrl.capacity_chart_exist', ()->
    it 'returns true if instances data is not empty', ()->
      controller = $controller 'HomePageCtrl', { $window: $window }
      controller.load_data [
      	{
      		label:"instance1",
      		data:100
      	}
      ]
      expect plotter.pie_chart
        .toHaveBeenCalled()
      expect controller.capacity_chart_exist()
        .toEqual(true)
    
    it 'returns false if instances data is empty', ()->
      controller = $controller 'HomePageCtrl', { $window: $window }
      controller.load_data []
      expect plotter.pie_chart
        .not.toHaveBeenCalled()
      expect controller.capacity_chart_exist()
        .toEqual(false)