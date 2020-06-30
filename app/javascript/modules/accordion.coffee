window.Accordion = class Accordion
  constructor: (@$accordionEl) ->
    @enableToggling(@$accordionEl)

  enableToggling: ($accordionEl) ->
    $switchEl = $accordionEl.find(".js-switch")
    $targetEl = $accordionEl.find(".js-target")

    $accordionEl.find(".js-trigger").click( (ev) ->
      $switchEl.toggleClass('is-open is-closed')
      $targetEl.toggleClass('u-hide')
    )
