window.Table = class Table
  DEFAULTS = {
    "bPaginate": false,
    "bLengthChange": false,
    "bFilter": false,
    "bInfo": false,
    "sScrollY": "400px",
    "scrollCollapse": true,
    "bDestroy": true
  }

  constructor: (@el, @$container_el, @opts) ->
    @reload()

  reload: ->
    table_opts = $.extend({}, DEFAULTS, @opts)
    table = $(@el).DataTable(table_opts)
    new $.fn.dataTable.FixedColumns(table) if @el == '.vulnerability-table'

  loading: => @$container_el.find('.overlay').removeClass('hidden')
  ready:   => @$container_el.find('.overlay').addClass('hidden')
