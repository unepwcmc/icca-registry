$(document).ready( ->
  $('.js-close-explore').click( (ev) ->
    $('.js-explore-target').fadeOut()
  )

  if ($mapEl = $('#map')).length > 0
    new Map($mapEl)

  $('.js-dropdown').each (i, el) -> new Dropdown($(el))
)
