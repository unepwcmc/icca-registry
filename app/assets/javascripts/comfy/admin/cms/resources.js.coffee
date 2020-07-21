$(document).ready( ->
  if ($addResourcesEl = $(".js-add-resources")).length > 0
    $addResourcesEl.find(".js-trigger-resources").click( (ev) ->
      ev.preventDefault()

      $addResourcesEl.find(".js-target-resources").append("""
        <input type="text" name="resources[][label]" placeholder="Label" class="form-control">
        <input type="file" name="resources[][file]" placeholder="File" class="form-control">
      """)

      $addResourcesEl.find(".js-target-resources").addClass('py-2')

      $jsButtonsResources = $(".js-buttons-resources")
      
      if $('.js-cancel-resources').length == 0
        $jsButtonsResources.append("""
          <button class="js-cancel-resources btn btn-danger">Cancel</button>
        """)


      $jsButtonsResources.on('click', '.js-cancel-resources', (event) -> 
          event.preventDefault()

          parentNode = document.querySelector(".js-target-resources")
          childInputs = parentNode.childNodes

          childInputs.forEach((node) => node.remove() ) 

          $addResourcesEl.find(".js-target-resources").removeClass('py-2')

          $(this).remove()
      )
    )


  if ($addrelatedLinksEl = $(".js-add-related-links")).length > 0
    $addrelatedLinksEl.find(".js-trigger-related-links").click( (ev) ->
      ev.preventDefault()

      $addrelatedLinksEl.find(".js-target-related-links").append("""
          <input type="text" name="related_links[][label]" placeholder="Label" class="form-control">
          <input type="url" name="related_links[][url]" placeholder="URL" class="form-control">
      """)

      $addrelatedLinksEl.find(".js-target-related-links").addClass('py-2')

      $jsButtonsLinks = $(".js-buttons-related-links")
      
      if $('.js-cancel-related-links').length == 0
        $jsButtonsLinks.append("""
          <button class="js-cancel-related-links btn btn-danger">Cancel</button>
        """)
      
      $jsButtonsLinks.on('click', '.js-cancel-related-links', (event) -> 
          event.preventDefault()

          parentNode = document.querySelector(".js-target-related-links")
          childInputs = parentNode.childNodes

          childInputs.forEach((node) => node.remove() ) 
          $addrelatedLinksEl.find(".js-target-related-links").removeClass('py-2')
          $(this).remove()
      )
  )
)