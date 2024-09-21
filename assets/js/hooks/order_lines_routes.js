// assets/js/hooks/order_lines_today_hook.js

const OrderLinesRoutesHook = {
    mounted() {
        const rouge = 'rgba(232, 0, 0, 1)'
        const orange = 'rgba(255, 143, 0, 1)'
        const bleu = 'rgba(24, 134, 224, 1)'
        const vert = 'rgba(76, 175, 80, 1)'
        const mauve = 'rgba(149, 97, 226, 1)'
        
        // Stacked chart for routes
        const routeCtx = document.getElementById('route-chart').getContext('2d');
        const routes = new Chart(routeCtx, {
            type: 'bar',
            data: {
            labels: ['Autres', 'Routes 300','Routes 100'],
            datasets: [
                {
                label: 'Pickées',
                data: [0, 0, 0],
                backgroundColor: bleu,
                stack: 'Pickées',
                },
                {
                label: 'Imprimées',
                data: [0, 0, 0],
                backgroundColor: orange,
                stack: 'Imprimées',
                },
                {
                label: 'À faire',
                data: [0, 0, 0],
                backgroundColor: rouge,
                stack: 'À faire',
                }
            ]
            },
            options: {
            responsive: true,
            scales: {
                x: {
                stacked: true,
                display: true,
                title: {
                    display: true,
                    text: 'Catégorie de transport',
                    font: {
                        weight: 'bold',
                    },
                }

                },
                y: {
                stacked: true,
                beginAtZero: true,
                title: {
                    display: true,
                    text: 'Lignes de commandes',
                    font: {
                        weight: 'bold',
                    },
                },
                    ticks: {
                        // forces step size to be 50 units
                        stepSize: 10
                        },
                        max: 200
                //type: 'logarithmic',
                }
            },
            plugins: {
                legend: {
                    display: true,
                    position: 'bottom'
                }
            }
            }
        });
      this.fetchData(routes);
      this.timer = setInterval(() => this.fetchData(routes), 5 * 60 * 1000); // 5 minutes interval
    },
  
    destroyed() {
      clearInterval(this.timer);
    },
  
    fetchData(routes) {
      // chart par types
    // chart par routes
    fetch('/api/nb_commandes_ln_routes')
      .then(response => response.json())  // Parse JSON response
      .then(data => {
        // Update the DOM with the fetched data

        let autres = data.findIndex(item => item.type === 'AUTRES');
        let routes300 = data.findIndex(item => item.type === 'ROUTES 300');
        let routes100 = data.findIndex(item => item.type === 'ROUTES 100');
        
        if(typeof data[autres] !== 'undefined' && autres !== -1){
            routes.data.datasets[0].data[0] = data[autres].completees;
            routes.data.datasets[1].data[0] = data[autres].imprimees;
            routes.data.datasets[2].data[0] = data[autres].afaire;
        }

        if(typeof data[routes300] !== 'undefined' && routes300 !== -1){
            routes.data.datasets[0].data[1] = data[routes300].completees;
            routes.data.datasets[1].data[1] = data[routes300].imprimees;
            routes.data.datasets[2].data[1] = data[routes300].afaire;
        }
        
        if(typeof data[routes100] !== 'undefined' && routes300 !== -1){
            routes.data.datasets[0].data[2] = data[routes100].completees;
            routes.data.datasets[1].data[2] = data[routes100].imprimees;
            routes.data.datasets[2].data[2] = data[routes100].afaire;
        }

        //routes.data.datasets[0].data[2] = data.value;
        routes.update()
      })
    },
  };
  
  export default OrderLinesRoutesHook;
  