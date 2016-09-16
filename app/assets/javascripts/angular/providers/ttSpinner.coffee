@bearsNg.factory "ttspinner", ["$uibModal",($uibModal)->
  modal = null
  spinner = {
    show: () ->
      spinner.modal = $uibModal.open {
        animation: true,
        ariaLabelledBy: 'modal-title',
        ariaDescribedBy: 'modal-body',
        templateUrl: 'modals/spinnerModal.html',
        size: "sm",
      }
      # we do not process any result, all we need is to close it at the right time
      # this is here to satisfy the mocked modal in test
      spinner.modal.result.then (answer) ->
        return
      , (result) -> 
      spinner.state = true
    hide: () -> 
      spinner.modal.close("")
      spinner.state = false
    state: null
  }
]