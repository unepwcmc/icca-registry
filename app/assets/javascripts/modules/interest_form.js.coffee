window.InterestForm = class InterestForm
  constructor: ->
    $form = $("[data-interest-form]")
    $modal = $form.closest("[data-interest-modal]")
    $success = $("[data-interest-success]")

    $form.submit((ev) ->
      ev.preventDefault()
      console.log("form submitted")
      url = $(this).attr("action")

      $.post(url, $(@).serialize(), (_response) ->
        $modal.hide()
        $success.show()
        $success.find()
      )

    )
