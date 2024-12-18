const MapboxInteraction = {
    mounted() {
      // Retrieve MapBox token and polygon data from data attributes
      const mapboxToken = this.el.dataset.mapboxToken;
      const polygonsData = JSON.parse(this.el.dataset.polygons);
      
      // Set the access token
      mapboxgl.accessToken = mapboxToken;
      
      // Create the map
      const map = new mapboxgl.Map({
        container: this.el,
        style: 'mapbox://styles/mapbox/streets-v11',
        center: [-73.470532, 45.474462],  // Default center
        zoom: 8
      });
  
      // Wait for map to load before adding sources and layers
      map.on('load', () => {
        // Add each polygon to the map
        polygonsData.forEach(polygon => {
          // Add a source for the polygon
          map.addSource(polygon.id, {
            'type': 'geojson',
            'data': {
              'type': 'Feature',
              'geometry': {
                'type': 'Polygon',
                'coordinates': [polygon.coordinates]
              }
            }
          });
  
          // Add a layer to visualize the polygon
          map.addLayer({
            'id': polygon.id,
            'type': 'fill',
            'source': polygon.id,
            'layout': {},
            'paint': {
              'fill-color': polygon.color,
              'fill-opacity': 0.5
            }
          });
  
          // Add a border to the polygon
          map.addLayer({
            'id': `${polygon.id}-border`,
            'type': 'line',
            'source': polygon.id,
            'layout': {},
            'paint': {
              'line-color': polygon.color,
              'line-width': 2
            }
          });

          // Add polygon name as a label
        // Calculate the center of the polygon for label placement
        const center = calculatePolygonCenter(polygon.coordinates[0]);

        // Add label source
        map.addSource(`${polygon.id}-label`, {
          'type': 'geojson',
          'data': {
            'type': 'Feature',
            'geometry': {
              'type': 'Point',
              'coordinates': center
            }
          }
        });

        // Add label layer
        map.addLayer({
          'id': `${polygon.id}-label`,
          'type': 'symbol',
          'source': `${polygon.id}-label`,
          'layout': {
            'text-field': polygon.name,
            'text-font': ['Arial Unicode MS Bold'],
            'text-size': 12,
            'text-anchor': 'center'
          },
          'paint': {
            'text-color': '#000000',
            'text-halo-color': '#FFFFFF',
            'text-halo-width': 2
          }
        });
  
          // Create popup for each polygon
          const popup = new mapboxgl.Popup({
            closeButton: false,
            closeOnClick: false
          });
  
          // Hover interactions
          map.on('mouseenter', polygon.id, (e) => {
            map.getCanvas().style.cursor = 'pointer';
            popup
              .setLngLat(e.lngLat)
              .setHTML(`<h3>${polygon.name}</h3>`)
              .addTo(map);
          });
  
          map.on('mouseleave', polygon.id, () => {
            map.getCanvas().style.cursor = '';
            popup.remove();
          });
        });
      });

    this.handleEvent("map-center", ({lat, lon}) => {
      map.flyTo({
        center: [lon, lat],
        zoom: 14
      });

      // Optionally add a marker
      new mapboxgl.Marker()
        .setLngLat([lon, lat])
        .addTo(map);
    });
     // Helper function to calculate polygon center
     function calculatePolygonCenter(coordinates) {
      let sumLat = 0;
      let sumLon = 0;
      
      coordinates.forEach(coord => {
        sumLon += coord[0];
        sumLat += coord[1];
      });

      return [
        sumLon / coordinates.length,
        sumLat / coordinates.length
      ];
    }
  
  }
  };
  
  export default MapboxInteraction;