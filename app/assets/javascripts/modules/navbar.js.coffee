window.Navbar = class Navbar
  @initialize: ->
    instance = new Navbar()
    instance.initialize()

  initialize: ->
    $('.js-navbar-actionable').click( (ev) ->
      $el = $(@)
      $el.toggleClass('navbar__element--dark')
    ).each( (_i, el) =>
      @addDropdown $(el)
    )

  addDropdown: ($el) ->
    new Dropdown($el.find('.js-trigger'), $el.find('.js-target'))
