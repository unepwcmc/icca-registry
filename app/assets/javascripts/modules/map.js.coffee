$.support.cors = true

window.Map = class Map
  PP_API_BASE = "http://api.protectedplanet.net"
  PP_API_KEY  = "0d6d9a0bf7a82b508e0d809eb78b0904"

  constructor: (@$mapEl) ->
    @config = @$mapEl.data()
    @initMap()

  initMap: ->
    @getBounds( (bounds) =>
      window.map = map = new L.Map(@$mapEl.attr('id'), {
        scrollWheelZoom: false,
        zoomControl: false,
        center: bounds.getCenter(),
        zoom: 3
      })

      map.on('dragstart click', @hideExplore)


      map.fitBounds(bounds)
      map.addControl(L.control.zoom(position: 'bottomright'))

      access_token = 'pk.eyJ1IjoidW5lcHdjbWMiLCJhIjoiY2lreHdmcmVlMDA0YndsbTQ5aHFwdm5vZyJ9.KsDsvf9FRGyv1BQYXblI0Q'
      L.tileLayer("https://api.mapbox.com/v4/unepwcmc.l8gj1ihl/{z}/{x}/{y}.png?access_token=#{access_token}").addTo(map)
      @addMarkers()
    )

    #@addLayer(map)
    #

  addMarkers: =>
    if @config.countryIso
      $.getJSON("/api/countries/#{@config.countryIso}", (data) => @addSites(data.icca_sites))
    else
      $.getJSON("/api/icca_sites", @addSites)

  addSites: (sites) ->
    markersGroup = L.featureGroup()

    for index, site of sites
      marker = L.marker([site.lat, site.lon])
      marker.bindPopup("""
        <a class='link-with-icon' href='/#{site.pages[0].site.path}#{site.pages[0].full_path}'>#{site.name}</a>
      """)
      markersGroup.addLayer(marker)
    markersGroup.addTo(window.map)
    window.map.fitBounds(markersGroup.getBounds())


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


  getBounds: (next) ->
    if @config.countryIso
      $.getJSON("#{PP_API_BASE}/v3/countries/#{@config.countryIso}?token=#{PP_API_KEY}", (data) ->
        next(L.geoJson(data.country.geojson).getBounds())
      )
    else
      next(L.latLngBounds(@config.boundFrom, @config.boundTo))

  hideExplore: ->
    $('.js-explore-target').fadeOut()
    $('.download-type-dropdown').fadeOut()
