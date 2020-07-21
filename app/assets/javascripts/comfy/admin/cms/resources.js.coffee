$(document).ready( ->
  if ($addResourcesEl = $(".js-add-resources")).length > 0
    $addResourcesEl.find(".js-trigger-resources").click( (ev) ->
      ev.preventDefault()

      $addResourcesEl.find(".js-target-resources").append("""
        <input type="text" name="resources[][label]" placeholder="Label" class="form-control">
        <input type="file" name="resources[][file]" placeholder="File" class="form-control">
      """)

      $jsButtons = $(".js-buttons-resources")
      
      $jsButtons.append("""
        <button class="js-cancel-resources btn btn-danger">Cancel</button>
      """)

      $jsCancel = $('.js-cancel-resources') 

      $jsCancel.click((event) -> 
          event.preventDefault()

          parentNode = document.querySelector(".js-target-resources")
          childNodes = document.querySelector(".js-target-resources").childNodes

          childNodes.forEach((node) => parentNode.removeChild(node))

          cancelButton = document.querySelector(".js-cancel-resources")
          cancelButton.parentNode.removeChild(cancelButton)
      )
    )


  if ($addrelatedLinksEl = $(".js-add-related-links")).length > 0
    $addrelatedLinksEl.find(".js-trigger-related-links").click( (ev) ->
      ev.preventDefault()

      $addrelatedLinksEl.find(".js-target-related-links").append("""
        <input type="text" name="related_links[][label]" placeholder="Label" class="form-control">
        <input type="url" name="related_links[][url]" placeholder="URL" class="form-control">
      """)

      $jsButtons = $(".js-buttons-related-links")
      
      $jsButtons.append("""
        <button class="js-cancel-related-links btn btn-danger">Cancel</button>
      """)
      
      $jsCancel = $('.js-cancel-related-links') 

      $jsCancel.click((event) -> 
          event.preventDefault()

          parentNode = document.querySelector(".js-target-related-links")
          childNodes = document.querySelector(".js-target-related-links").childNodes

          childNodes.forEach((node) => parentNode.removeChild(node))

          cancelButton = document.querySelector(".js-cancel-related-links")
          cancelButton.parentNode.removeChild(cancelButton)
      )
  )
)