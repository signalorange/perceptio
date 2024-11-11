// assets/js/hooks/order_lines_today_hook.js

const OrderLinesTypesHook = {
    mounted() {
        this.initChart()
        const chartData = JSON.parse(this.el.dataset.chart)
        this.convertData(chartData);
      //this.timer = setInterval(() => this.fetchData(chart), 5 * 60 * 1000); // 5 minutes interval
    },

    updated() {
        const newData = JSON.parse(this.el.dataset.chart)
        //console.log("update received, order_lines_status", newData);
        this.convertData(newData)
      },
  
    initChart() {
        const livrees = 'rgba(34, 136, 51, 1)' // vert 228833
        const restantes = 'rgba(149, 97, 226, 1)' // mauve 9561e2
        const pickees = 'rgba(232, 34, 34, 1)' // rouge e22222
        //const pretes = 'rgba(232, 90, 0, 1)'// orange e85a00
        const pretes = 'rgba(239, 185, 7, 1)' // jaune efb907
        //const imprimees = 'rgba(239, 185, 7, 1)' // jaune efb907
        const imprimees = 'rgba(34, 136, 51, 1)' // vert 228833
        const a_faire = 'rgba(39, 79, 221, 1)' // bleu 274fdd

        // Stacked chart for Lignes de câbles
        const typesCtx = document.getElementById('cable-chart').getContext('2d');
        this.chart = new Chart(typesCtx, {
            type: 'bar',
            data: {
            labels: ['Produits en tablette', 'Produits câbles', 'Produits extérieurs'],
            datasets: [
                {
                label: 'Pickées',
                data: [0, 0, 0],
                backgroundColor: pickees,
                //stack: 'Pickées',
                //borderWidth: 1,
                borderColor: 'white',
                borderWidth: {
                    top: 1,
                }
                },
                {
                    label: 'Prêtes',
                    data: [0, 0, 0],
                    backgroundColor: pretes,
                    //stack: 'Imprimées',
                    //borderWidth: 1,
                    borderColor: 'white',
                    borderWidth: {
                        top: 1,
                    }
                    },
                {
                label: 'Imprimées',
                data: [0, 0, 0],
                backgroundColor: imprimees,
                //stack: 'Imprimées',
                //borderWidth: 1,
                borderColor: 'white',
                borderWidth: {
                    top: 1,
                }
                },
                {
                label: 'À faire',
                data: [0, 0, 0],
                backgroundColor: a_faire,
                //stack: 'À faire',
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
                    text: 'Catégorie de produit',
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
      //this.timer = setInterval(() => this.fetchData(types), 5 * 60 * 1000); // 5 minutes interval
    },

    convertData(data) {
        // chart par types

        // Update the DOM with the fetched data

        let stocks = data.findIndex(item => item.type === 0);
        let cables = data.findIndex(item => item.type === 1);
        let exts = data.findIndex(item => item.type === 2);
        let total_stocks = 0;
        let total_cables = 0;
        let total_exts = 0;
        
        if(typeof data[stocks] !== 'undefined' && stocks !== -1){
            this.chart.data.datasets[0].data[0] = data[stocks].completees;
            this.chart.data.datasets[1].data[0] = data[stocks].pretes;
            this.chart.data.datasets[2].data[0] = data[stocks].imprimees;
            this.chart.data.datasets[3].data[0] = data[stocks].afaire;
            total_stocks = data[stocks].completees+data[stocks].pretes+data[stocks].imprimees+data[stocks].afaire;
            this.chart.data.labels[0] = [total_stocks,'Produits en tablette'];
        }
        
        if(typeof data[cables] !== 'undefined' && cables !== -1){
            this.chart.data.datasets[0].data[1] = data[cables].completees;
            this.chart.data.datasets[1].data[1] = data[cables].pretes;
            this.chart.data.datasets[2].data[1] = data[cables].imprimees;
            this.chart.data.datasets[3].data[1] = data[cables].afaire;
            total_cables = data[cables].completees+data[cables].pretes+data[cables].imprimees+data[cables].afaire;
            this.chart.data.labels[1] = [total_cables,'Produits câbles'];
        }

        if(typeof data[exts] !== 'undefined' && exts !== -1){
            this.chart.data.datasets[0].data[2] = data[exts].completees;
            this.chart.data.datasets[1].data[2] = data[exts].pretes;
            this.chart.data.datasets[2].data[2] = data[exts].imprimees;
            this.chart.data.datasets[3].data[2] = data[exts].afaire;
            total_exts = data[exts].completees+data[exts].pretes+data[exts].imprimees+data[exts].afaire;
            this.chart.data.labels[2] = [total_exts,'Produits extérieurs'];
        }

        // vérifier le total des lignes, pour adapter le graphique
        const maxTotal = Math.max(total_stocks, total_cables, total_exts);

        // Adjust the y-axis scale
        let yAxisMax;
        if (maxTotal <= 50) {
            yAxisMax = 50;
        } else if (maxTotal <= 100) {
            yAxisMax = 100;
        } else if (maxTotal <= 200) {
            yAxisMax = 200;
        } else {
            yAxisMax = 300;
        }

        // Update the chart options
        this.chart.options.scales.y.max = yAxisMax;


        //types.data.datasets[0].data[2] = data.value;
        this.chart.update()

    },
  
  };
  
  export default OrderLinesTypesHook;
  