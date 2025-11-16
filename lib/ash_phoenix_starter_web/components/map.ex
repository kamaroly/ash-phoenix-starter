defmodule AshPhoenixStarterWeb.Map do
  use AshPhoenixStarterWeb, :html

  def map(assigns) do
    ~H"""
    <script src={~p"/assets/js/congo-brazaville.js"}>
    </script>

    <link
      rel="stylesheet"
      href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
      integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
      crossorigin=""
    />
    <script
      src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
      integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
      crossorigin=""
    >
    </script>

    <div id="map" phx-hook=".Map" class="h-96" style="height:680px;"></div>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".Map">
              export default {
                mounted() {

          const map = L.map('map').setView([-1, 15], 7);

          const tiles = L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
          maxZoom: 19,
          attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
          }).addTo(map);

          // control that shows state info on hover
          const info = L.control();

          info.onAdd = function (map) {
          this._div = L.DomUtil.create('div', 'info');
          this.update();
          return this._div;
          };

          info.update = function (props) {
          const contents = props ? `<b>${props.name}</b><br />Stock availability: ${props.density}` : 'Hover over a province';
          this._div.innerHTML = `<h4>Merchant Stock Availability</h4>${contents}`;
          };

          info.addTo(map);

      // Add legend for stock levels
          const legend = L.control({ position: 'bottomright' });
          legend.onAdd = function (map) {
            const div = L.DomUtil.create('div', 'info legend');
            div.style.backgroundColor = 'white';
            div.style.padding = '10px';
            div.style.border = '1px solid black';
            div.innerHTML += '<strong>Stock Levels</strong><br>';
            div.innerHTML += '<i style="background: orangered; width: 18px; height: 18px; display: inline-block; margin-right: 5px;"></i> Low (&lt;20)<br>';
            div.innerHTML += '<i style="background: gold; width: 18px; height: 18px; display: inline-block; margin-right: 5px;"></i> Medium (20-49)<br>';
            div.innerHTML += '<i style="background: lime; width: 18px; height: 18px; display: inline-block; margin-right: 5px;"></i> High (50+)<br>';
            return div;
          };
          legend.addTo(map);

          function getColor(stockLevel) {
          return stockLevel > 1000 ? '#00ff00' :
                 stockLevel > 20   ? '#ffcc07' : '#ff4500'
          }

          function getRandomNumber(min, max) {
            return Math.floor(Math.random() * (max - min + 1)) + min;
          }

          function style(province) {
            var stockLevel = getRandomNumber(0, 1500)
            var stockColor = getColor(stockLevel)
            return {
                weight: 2,
                opacity: 0.9,
                dashArray: '3',
                fillOpacity: 0.7,
                fillColor: stockColor,
                color: '#000000'
            };
          }

          function highlightFeature(e) {
              const layer = e.target;

              layer.setStyle({
                  weight: 5,
                  color: '#000',
                  dashArray: '',
                  fillOpacity: 0.7
              });

              layer.bringToFront();

              info.update(layer.feature.properties);
          }

          /* global statesData */
          const geojson =
           L
           .geoJson(statesData, {style, onEachFeature}).addTo(map);

          function resetHighlight(e) {
            geojson.resetStyle(e.target);
            info.update();
          }

          function zoomToFeature(e) {
            map.fitBounds(e.target.getBounds());
          }

          function onEachFeature(feature, layer) {
              layer.on({
                  mouseover: highlightFeature,
                  mouseout: resetHighlight,
                  click: zoomToFeature
              });
          }

          map.attributionControl.addAttribution('Population data &copy; <a href="http://census.gov/">US Census Bureau</a>');

                  }
                }
    </script>
    """
  end
end
