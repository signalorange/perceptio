// assets/js/hooks/order_lines_today_hook.js

const OrderLinesRoutesHook = {
    mounted() {
        this.initChart()
        const chartData = JSON.parse(this.el.dataset.chart)
        this.convertData(chartData);
      //this.timer = setInterval(() => this.fetchData(chart), 5 * 60 * 1000); // 5 minutes interval
    },

    updated() {
        const newData = JSON.parse(this.el.dataset.chart)
        console.log("update received, order_lines_status", newData);
        this.convertData(newData)
      },

    initChart() {
        const livrees = 'rgba(34, 136, 51, 1)' // vert
        const restantes = 'rgba(149, 97, 226, 1)' // mauve
        const pickees = 'rgba(238, 102, 119, 1)' //rose
        const pretes = 'rgba(204, 187, 68, 1)' // jaune
        const imprimees = 'rgba(102, 204, 238, 1)' // bleu pale
        const a_faire = 'rgba(68, 119, 170, 1)' // bleu
        
        // Stacked chart for routes
        const routeCtx = document.getElementById('route-chart').getContext('2d');
        this.chart = new Chart(routeCtx, {
            type: 'bar',
            data: {
            labels: ['Autres', 'Routes 300','Routes 100'],
            datasets: [
                {
                label: 'Pickées',
                data: [0, 0, 0],
                backgroundColor: pickees,
                stack: 'Pickées',
                },
                {
                label: 'Prêtes',
                data: [0, 0, 0],
                backgroundColor: pretes,
                stack: 'Prêtes',
                },
                {
                label: 'Imprimées',
                data: [0, 0, 0],
                backgroundColor: imprimees,
                stack: 'Imprimées',
                },
                {
                label: 'À faire',
                data: [0, 0, 0],
                backgroundColor: a_faire,
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
                    display: false,
                    text: 'Catégorie de routes',
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
      //this.fetchData(routes);
      //this.timer = setInterval(() => this.fetchData(routes), 5 * 60 * 1000); // 5 minutes interval
    },
  
    destroyed() {
      //clearInterval(this.timer);
    },
  
    convertData(data) {
        // chart par routes
        // Update the DOM with the fetched data

        let autres = data.findIndex(item => item.type === 'AUTRES');
        let routes300 = data.findIndex(item => item.type === 'ROUTES 300');
        let routes100 = data.findIndex(item => item.type === 'ROUTES 100');
        let total_autres = 0;
        let max_autres = 0;
        let total_routes300 = 0;
        let max_routes300 = 0;
        let total_routes100 = 0;
        let max_routes100 = 0;
        
        if(typeof data[autres] !== 'undefined' && autres !== -1){
            this.chart.data.datasets[0].data[0] = data[autres].completees;
            this.chart.data.datasets[1].data[0] = data[autres].pretes;
            this.chart.data.datasets[2].data[0] = data[autres].imprimees;
            this.chart.data.datasets[3].data[0] = data[autres].afaire;
            total_autres = data[autres].completees+data[autres].pretes+data[autres].imprimees+data[autres].afaire;
            max_autres = Math.max(data[autres].completees, data[autres].pretes, data[autres].imprimees, data[autres].afaire)
            this.chart.data.labels[0] = [total_autres,'Autres'];
        }

        if(typeof data[routes300] !== 'undefined' && routes300 !== -1){
            this.chart.data.datasets[0].data[1] = data[routes300].completees;
            this.chart.data.datasets[1].data[1] = data[routes300].pretes;
            this.chart.data.datasets[2].data[1] = data[routes300].imprimees;
            this.chart.data.datasets[3].data[1] = data[routes300].afaire;
            total_routes300 = data[routes300].completees+data[routes300].pretes+data[routes300].imprimees+data[routes300].afaire;
            max_routes300 = Math.max(data[routes300].completees, data[routes300].pretes, data[routes300].imprimees, data[routes300].afaire)
            this.chart.data.labels[1] = [total_routes300,'Routes 300'];
        }
        
        if(typeof data[routes100] !== 'undefined' && routes100 !== -1){
            this.chart.data.datasets[0].data[2] = data[routes100].completees;
            this.chart.data.datasets[1].data[2] = data[routes100].pretes;
            this.chart.data.datasets[2].data[2] = data[routes100].imprimees;
            this.chart.data.datasets[3].data[2] = data[routes100].afaire;
            total_routes100 = data[routes100].completees+data[routes100].pretes+data[routes100].imprimees+data[routes100].afaire;
            max_routes100 = Math.max(data[routes100].completees, data[routes100].pretes, data[routes100].imprimees, data[routes100].afaire)
            this.chart.data.labels[2] = [total_routes100,'Routes 100'];
        }
        // vérifier le total des lignes, pour adapter le graphique
        const maxTotal = Math.max(max_autres, max_routes300, max_routes100);

        // Adjust the y-axis scale
        let yAxisMax;
        if (maxTotal <= 100) {
            yAxisMax = 100;
        } else if (maxTotal <= 200) {
            yAxisMax = 200;
        } else {
            yAxisMax = 300;
        }

        // Update the chart options
        this.chart.options.scales.y.max = yAxisMax;

        //routes.data.datasets[0].data[2] = data.value;
        this.chart.update()
    },
  };
  
  export default OrderLinesRoutesHook;
  