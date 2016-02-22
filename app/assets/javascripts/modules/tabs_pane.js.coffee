window.TabsPane = class TabsPane
  constructor: (@$container_el, @table, @table_type) ->
    @opts = @$container_el.find('li > a')
    @val = ''
    @index = -1
    @initEvents()

  initEvents: ->
    @$container_el.on('click', (event) ->
      event.preventDefault()
    )

    self = @
    @opts.on('click', ->
      opt = $(this)
      if opt.hasClass("active")
        return
      else
        self.$container_el.find(".active").removeClass("active")
        opt.closest('li').addClass("active")
      self.val = opt.text()
      self.index = opt.index()
      wdpa_id = $('#map').data("wdpa-id")

      self.table.loading()
      $.ajax(
        url: "#{wdpa_id}/#{self.table_type}?taxonomic_class=#{self.val}"
        error: (jqXHR, textStatus, errorThrown) ->
          console.log("AJAX Error: #{textStatus}")
        success: (data, textStatus, jqXHR) ->
          self.table.$container_el.html(data)
          self.table.reload()
          self.table.ready()
      )
    )

  getValue: -> @val
  getIndex: -> @index
