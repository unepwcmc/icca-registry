$(document).ready( ->
  if ($addResourcesEl = $(".js-add-resources")).length > 0
    $addResourcesEl.find(".js-trigger").click( (ev) ->
      ev.preventDefault()

      $addResourcesEl.find(".js-target").append("""
        <input type="text" name="resources[][label]" placeholder="Label" class="form-control">
        <input type="file" name="resources[][file]" placeholder="File" class="form-control">
      """)

      $jsButtons = $(".js-buttons")
      
      $jsButtons.append("""
        <button class="js-cancel btn btn-danger">Cancel</button>
      """)

      $jsCancel = $('.js-cancel') 

      $jsCancel.click((event) -> 
          event.preventDefault()

          parentNode = document.querySelector(".js-target")
          childNodes = document.querySelector(".js-target").childNodes

          childNodes.forEach((node) => parentNode.removeChild(node))

          cancelButton = document.querySelector(".js-cancel")
          cancelButton.parentNode.removeChild(cancelButton)
      )
    )


  if ($addrelatedLinksEl = $(".js-add-related-links")).length > 0
    $addrelatedLinksEl.find(".js-trigger").click( (ev) ->
      ev.preventDefault()

      $addrelatedLinksEl.find(".js-target").append("""
        <input type="text" name="related_links[][label]" placeholder="Label" class="form-control">
        <input type="url" name="related_links[][url]" placeholder="URL" class="form-control">
      """)

      $jsButtons = $(".js-buttons")
      
      $jsButtons.append("""
        <button class="js-cancel btn btn-danger">Cancel</button>
      """)
      
      $jsCancel = $('.js-cancel') 

      $jsCancel.click((event) -> 
          event.preventDefault()

          parentNode = document.querySelector(".js-target")
          childNodes = document.querySelector(".js-target").childNodes

          childNodes.forEach((node) => parentNode.removeChild(node))

          cancelButton = document.querySelector(".js-cancel")
          cancelButton.parentNode.removeChild(cancelButton)
      )
  )
)