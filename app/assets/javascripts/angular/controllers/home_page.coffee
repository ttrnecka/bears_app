(->
  HomePageCtrl = ($scope,$window) ->
     plotter = $window.bearsApp.utils.plotter
     
     detailed_data = [
       {
         label:"Used"
         data: [
           [1, 1000 ], [2.5, 2000 ]
         ]
       },
       {
         label:"Free"
         data: [
           [1, 2000 ], [2.5, 1500 ]
         ]
       }
     ]
     $scope.charts = {}
     $scope.initialize = (instances_data) ->	
       $scope.charts.capacity = plotter.pie_chart($('#chart_capacity'),instances_data) if instances_data.length>0
       $scope.charts.capacity = plotter.stack_chart($('#chart_capacity_detailed'),detailed_data)
       return
     
     $scope.capacity_chart_exist = () ->
       if $scope.charts.capacity then true else false
     
     $scope.capacity_chart_detailed_exist = () ->
       true
         
     return
   
  angular
    .module("bearsApp")
    .controller("HomePageCtrl", [ '$scope','$window', HomePageCtrl ])

)()