describe 'HomePageCtrl', ()->
  beforeEach(module('bearsApp'))

  $controller = null
  $window = null
  plotter = null

  beforeEach inject (_$controller_,_$window_)->
    $controller = _$controller_;
    $window = _$window_;
    plotter = $window.bearsApp.utils.plotter
    
    spyOn(plotter,'pie_chart').and.returnValue({obj:true})
    return
    
  describe '$scope.capacity_chart_exist', ()->
    it 'returns true if instances data is not empty', ()->
      $scope = {};
      controller = $controller 'HomePageCtrl', { $scope: $scope }
      $scope.initialize [
      	{
      		label:"instance1",
      		data:100
      	}
      ]
      expect plotter.pie_chart
        .toHaveBeenCalled()
      expect $scope.capacity_chart_exist()
        .toEqual(true)
    
    it 'returns false if instances data is empty', ()->
      $scope = {}
      controller = $controller 'HomePageCtrl', { $scope: $scope, $window: $window }
      $scope.initialize []
      expect plotter.pie_chart
        .not.toHaveBeenCalled()
      expect $scope.capacity_chart_exist()
        .toEqual(false)
  