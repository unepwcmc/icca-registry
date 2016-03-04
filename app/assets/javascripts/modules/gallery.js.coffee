window.Gallery = class Gallery
  INLINE_BLOCK_MARGIN = 4

  constructor: (@$el) ->
    @loadPhotos()
    @blurHidden()
    @activateControls()

  loadPhotos: ->
    @$windowEl = @$el.find('.js-window')
    @$photoEls = @$el.find('.js-photo')
    @currentIndex = 0
    @maxIndex = @$photoEls.length-1

  blurHidden: ->
    for photoEl in @$photoEls.slice(1)
      $(photoEl).addClass('is-blurred')

  activateControls: ->
    @$firstEl = @$el.find(".js-first")
    @$prevEl = @$el.find(".js-previous")
    @$nextEl = @$el.find(".js-next")
    @$lastEl = @$el.find(".js-last")

    @$currentIndexEl = @$el.find(".js-current-index")

    @$firstEl.click(=>
      @$prevEl.click() for [1..@maxIndex]
    )
    @$prevEl.click(=>
      return if @currentIndex == 0
      @updatePhoto('prev')
    )
    @$nextEl.click(=>
      return if @currentIndex == @maxIndex
      @updatePhoto('next')
    )
    @$lastEl.click(=>
      @$nextEl.click() for [1..@maxIndex]
    )

  updatePhoto: (direction) =>
    $oldPhotoEl = $(@$photoEls[@currentIndex])
    $oldPhotoEl.addClass('is-blurred')

    if direction == 'next'
      @currentIndex += 1
      @currentIndex = 0 if @currentIndex > @maxIndex
      @$currentIndexEl.html(@currentIndex+1)
      @moveWindow($oldPhotoEl, 'next')
    else
      @currentIndex -= 1
      @currentIndex = @maxIndex if @currentIndex < 0
      @$currentIndexEl.html(@currentIndex+1)

    $newPhotoEl = $(@$photoEls[@currentIndex])
    $newPhotoEl.removeClass('is-blurred')

    if direction == 'prev'
      @moveWindow($newPhotoEl, 'prev')


  moveWindow: ($photoEl, direction) =>
    photoWidth = $photoEl.outerWidth(true) + INLINE_BLOCK_MARGIN
    windowLeft = parseInt(@$windowEl.css('left'))

    if direction == 'prev'
      @$windowEl.css('left', windowLeft+photoWidth)
    else if direction == 'next'
      @$windowEl.css('left', windowLeft-photoWidth)
