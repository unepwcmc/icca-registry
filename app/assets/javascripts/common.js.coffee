$(document).ready( ->
  if ($mapEl = $('#map')).length > 0
    try
      new Map($mapEl)
    catch err
      console.error err

  $('.js-dropdown').each (i, el)  -> new Dropdown($(el))
  $('.js-accordion').each (i, el) -> new Accordion($(el))
  $('.js-gallery').each (i, el)   -> new Gallery($(el))
  $('.js-gallery').each (i, el)   -> new Gallery($(el))

  $('.js-close-explore').click( (ev) ->
    $('.js-explore-target').fadeOut()
  )

  new Toggle("interest")
  new BlockPage("interest")
  new InterestForm()

  new Toggle("success")
  new BlockPage("success")

  new Toggle("language-switch")

  setTimeout((-> $(".banner").addClass("animated")), 750)
)

