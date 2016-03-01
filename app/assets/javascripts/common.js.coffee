$(document).ready( ->
  if ($mapEl = $('#map')).length > 0
    try
      new Map($mapEl)
    catch err
      console.log(err)

  $('.js-dropdown').each (i, el) -> new Dropdown($(el))
  $('.js-accordion').each (i, el) -> new Accordion($(el))

)

