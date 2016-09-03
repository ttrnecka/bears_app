(->
  HomePageCtrl = ($scope,$window) ->
     $scope.charts = {}
     
     $scope.initialize = (instances_data) ->	
       $scope.charts.capacity = $window.plotter.pie_chart($('#chart_capacity'),instances_data);
       return
       
     return
   
  angular
    .module("bearsApp")
    .controller("HomePageCtrl", [ '$scope','$window', HomePageCtrl ])

)()