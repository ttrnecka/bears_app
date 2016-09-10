@bearsNg.controller "HomePageCtrl", [ '$window', ($window) ->
   @plotter = $window.FlotPlotter

   @default_stack_data = [
     {
       label:"Used"
       data: []
     },
     {
       label:"Free"
       data: []
     }
   ]
   @default_stack_options = {
     xaxis:
       ticks: []
       max:0
   }
   @charts = {}

   pull_pie_data = (instance_data)->
     tmp = {
       label:instance_data.label,
       data:instance_data.data_total
     }

   @load_data = (graph_data) =>
     if graph_data.instances and graph_data.instances.length > 0
       instance_total = (pull_pie_data instance for instance in graph_data.instances)
       @charts.capacity_distribution = @plotter.pie_chart($('#chart_capacity_distribution'),instance_total)

       # instance stack parsing
       @default_stack_data[0].data.push [i+0.1, instance.data_used] for instance,i in graph_data.instances
       @default_stack_data[1].data.push [i+0.1, instance.data_available] for instance,i in graph_data.instances
       @default_stack_options.xaxis.ticks.push [i+0.55, instance.label] for instance,i in graph_data.instances
       @default_stack_options.xaxis.max = graph_data.instances.length+0.1
       @charts.capacity_usage = @plotter.stack_chart($('#chart_capacity_usage'),@default_stack_data,@default_stack_options) if instance_total.length>0

     if graph_data.arrays and graph_data.arrays.length > 0
       # array stack parsing
       @default_stack_data[0].data = []
       @default_stack_data[1].data = []
       @default_stack_options.xaxis.ticks = []
       @default_stack_data[0].data.push [i+0.1, array.data_used] for array,i in graph_data.arrays
       @default_stack_data[1].data.push [i+0.1, array.data_available] for array,i in graph_data.arrays
       @default_stack_options.xaxis.ticks.push [i+0.55, array.label] for array,i in graph_data.arrays
       @default_stack_options.xaxis.max = graph_data.arrays.length+0.1
       @charts.capacity_usage_array = @plotter.stack_chart($('#chart_capacity_usage_array'),@default_stack_data,@default_stack_options) if graph_data.arrays.length>0
     return

   @capacity_distribution_chart_exist = () =>
     if @charts.capacity_distribution then true else false

   @capacity_usage_chart_exist = () =>
     if @charts.capacity_usage then true else false

   @capacity_usage_array_chart_exist = () =>
     if @charts.capacity_usage_array then true else false
     
   return
 ]