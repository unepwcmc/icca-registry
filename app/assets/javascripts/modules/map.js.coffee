window.Map = class Map
  constructor: (@$mapEl) ->
    @config = @$mapEl.data()
    @initMap()

  initMap: ->
    bounds = L.latLngBounds(@config.boundFrom, @config.boundTo)
    window.map = map = new L.Map(@$mapEl.attr('id'), {
      zoomControl: false,
      center: [30, 20],
      zoom: 3
    })

    map.fitBounds(bounds)
    map.addControl(L.control.zoom(position: 'bottomright'))

    access_token = 'pk.eyJ1IjoidW5lcHdjbWMiLCJhIjoiY2lreHdmcmVlMDA0YndsbTQ5aHFwdm5vZyJ9.KsDsvf9FRGyv1BQYXblI0Q'
    L.tileLayer("https://api.mapbox.com/v4/unepwcmc.l8gj1ihl/{z}/{x}/{y}.png?access_token=#{access_token}").addTo(map)

    #@addLayer(map)

  addLayer: (map) ->
    countries_css = @generateCartocss(DemoUtils.countries)
    countries_list = @parseCountries()

    cartodb.createLayer(map, {
      user_name: 'carbon-tool',
      type: 'cartodb',
      sublayers: [{
        sql: "SELECT * FROM ne_countries WHERE admin IN (#{countries_list})",
        cartocss: countries_css,
        interactivity: ['cartodb_id', 'admin']
      }]
    })
    .addTo(map)
    .done( (layer) ->
      info = layer.leafletMap.viz.addOverlay({
        type: 'tooltip',
        layer: layer.getSubLayer(0),
        template: '<div class="country-tooltip"><h4>{{admin}}</h4></div>',
        width: 200,
        position: 'bottom|right',
        fields: [{admin: 'admin'}]
      })
      $('#map').append(info.render().el)
    )
