window.BlockPage = class BlockPage
  constructor: (group) ->
    $("[data-block-page-trigger='#{group}']").on("shown", (_ev) ->
      $("body,html").css("overflow-y", "hidden")
    )

    $("[data-block-page-trigger='#{group}']").on("hidden", (_ev) ->
      $("body,html").css("overflow-y", "auto")
    )
