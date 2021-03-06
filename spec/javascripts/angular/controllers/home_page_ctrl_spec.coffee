describe 'HomePageCtrl', ()->
  beforeEach(module('bearsApp'))

  $controller = null
  $window = null
  plotter = null
  
  test_graph_data = {
    instances: [
      {
         label:"instance1"
      	 data_total:100
      	 data_used:50
      	 data_available:50
      }
    ]
    arrays: [
      {
        label:"array1"
        data_total:100
        data_used:50
        data_available:50
      }
    ]
  }

  beforeEach inject (_$controller_,_$window_)->
    $controller = _$controller_;
    $window = _$window_;
    plotter = $window.FlotPlotter
    
    spyOn(plotter,'pie_chart').and.returnValue({obj:true})
    spyOn(plotter,'stack_chart').and.returnValue({obj:true})
    return
    
  describe 'ctrl.capacity_distribution_chart_exist', ()->
    it 'returns true if instances data is not empty', ()->
      controller = $controller 'HomePageCtrl', { $window: $window }
      controller.load_data test_graph_data
      expect plotter.pie_chart
        .toHaveBeenCalled()
      expect controller.capacity_distribution_chart_exist()
        .toEqual(true)
    
    it 'returns false if instances data is empty', ()->
      controller = $controller 'HomePageCtrl', { $window: $window }
      controller.load_data []
      expect plotter.pie_chart
        .not.toHaveBeenCalled()
      expect controller.capacity_distribution_chart_exist()
        .toEqual(false)
        
   describe 'ctrl.capacity_usage_chart_exist', ()->
    it 'returns true if instances data is not empty', ()->
      controller = $controller 'HomePageCtrl', { $window: $window }
      controller.load_data test_graph_data
      expect plotter.stack_chart
        .toHaveBeenCalled()
      expect controller.capacity_usage_chart_exist()
        .toEqual(true)
    
    it 'returns false if instances data is empty', ()->
      controller = $controller 'HomePageCtrl', { $window: $window }
      controller.load_data []
      expect plotter.pie_chart
        .not.toHaveBeenCalled()
      expect controller.capacity_usage_chart_exist()
        .toEqual(false)
        
   describe 'ctrl.capacity_usage_array_chart_exist', ()->
    it 'returns true if arrays data is not empty', ()->
      controller = $controller 'HomePageCtrl', { $window: $window }
      controller.load_data test_graph_data
      expect plotter.stack_chart
        .toHaveBeenCalled()
      expect controller.capacity_usage_array_chart_exist()
        .toEqual(true)
    
    it 'returns false if arrays data is empty', ()->
      controller = $controller 'HomePageCtrl', { $window: $window }
      controller.load_data []
      expect plotter.pie_chart
        .not.toHaveBeenCalled()
      expect controller.capacity_usage_array_chart_exist()
        .toEqual(false)