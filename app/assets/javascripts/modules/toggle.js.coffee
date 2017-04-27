window.Toggle = class Toggle
  constructor: (group) ->
    $triggers = $("[data-toggle-trigger='#{group}']")
    $targets = $("[data-toggle-target='#{group}']")

    $triggers.click((ev) ->
      ev.preventDefault()
      $targets.toggle()
    )
