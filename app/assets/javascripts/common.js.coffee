$(document).ready( ->
  if ($mapEl = $('#map')).length > 0
    new Map($mapEl)

  $('.js-dropdown').each (i, el)  -> new Dropdown($(el))
  $('.js-accordion').each (i, el) -> new Accordion($(el))
  $('.js-gallery').each (i, el)   -> new Gallery($(el))

)

