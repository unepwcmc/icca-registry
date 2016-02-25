$(document).ready( ->
  if ($mapEl = $('#map')).length > 0
    new Map($mapEl)

  $('.js-dropdown').each (i, el) -> new Dropdown($(el))
)

