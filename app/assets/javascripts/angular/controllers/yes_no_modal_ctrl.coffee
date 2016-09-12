@bearsNg.controller 'YesNoModalCtrl', [ "$uibModalInstance", "question",($uibModalInstance, question) ->
  ctrl = @
  ctrl.question = question

  ctrl.yes = ->
    $uibModalInstance.close('yes')

  ctrl.no = ->
    $uibModalInstance.close('no')
  
  return
]