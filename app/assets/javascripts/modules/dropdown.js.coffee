window.Dropdown = class Dropdown
  constructor: (@$el, @options) ->
    @options ||= {on: 'click'}
    @addEventListener()

  addEventListener: ->
    $triggerEl = @$el.find('[data-dropdown-trigger]')
    $targetEl  = @$el.find('[data-dropdown-target]')

    $triggerEl.on(@options.on, (event) ->
      $triggerEl.toggleClass('active')
      $targetEl.slideToggle(100)

      event.preventDefault()
    )
