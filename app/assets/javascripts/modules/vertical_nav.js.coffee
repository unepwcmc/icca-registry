window.VerticalNav = class VerticalNav
  constructor: ($containerEl) ->
    classBase = 'vertical-nav__element'

    $containerEl.find('.js-toggle-section').click( (ev) ->
      $el = $(this)

      $el.toggleClass("#{classBase}--opened #{classBase}--closed")
      $el.next('div').toggleClass('u-hide')

      ev.preventDefault()
    )
