window.bearsApp =
  utils:
    locationHref: ()->
      window.location.href

app = window.bearsApp

metis_menu =
  highlightSection: ()->
    element = $('ul.nav a')
      .filter ->
        return app.utils.locationHref() == this.href
      .addClass 'active'
      .parents 'ul'
      .addClass 'in'
    element.addClass 'active' if element.is 'li'

document.addEventListener("turbolinks:load", ->
  #angular
  angular.bootstrap document.body, ['bearsApp']
  
  # metis menu
  $('#side-menu').metisMenu()
  # section highligh
  metis_menu.highlightSection() 
  
  return
)
