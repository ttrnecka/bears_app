@bearsNg.controller "HomePageCtrl", [ '$window', ($window) ->
   @plotter = $window.FlotPlotter
     
   @detailed_data = [
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
   @charts = {}
   @load_data = (instances_data) =>	
     @charts.capacity = @plotter.pie_chart($('#chart_capacity'),instances_data) if instances_data.length>0
     @charts.capacity_detailed = @plotter.stack_chart($('#chart_capacity_detailed'),@detailed_data)
     return
    
   @capacity_chart_exist = () =>
     if @charts.capacity then true else false
     
   @capacity_chart_detailed_exist = () =>
     if @charts.capacity_detailed then true else false
         
   return  
]