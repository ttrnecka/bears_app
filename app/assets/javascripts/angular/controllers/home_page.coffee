(->
  HomePageCtrl = ($scope,$window) ->
     plotter = $window.bearsApp.utils.plotter
     $scope.charts = {}
     $scope.initialize = (instances_data) ->	
       $scope.charts.capacity = plotter.pie_chart($('#chart_capacity'),instances_data) if instances_data.length>0
       return
     
     $scope.capacity_chart_exist = () ->
       if $scope.charts.capacity then true else false
         
     return
   
  angular
    .module("bearsApp")
    .controller("HomePageCtrl", [ '$scope','$window', HomePageCtrl ])

)()