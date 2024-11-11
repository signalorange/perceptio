// assets/js/hooks/order_lines_today_hook.js

const OrderLinesStatusHook = {
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

    initChart(){
        const livrees = 'rgba(34, 136, 51, 1)' // vert 228833
        const restantes = 'rgba(149, 97, 226, 1)' // mauve 9561e2
        const pickees = 'rgba(232, 34, 34, 1)' // rouge e22222
        //const pretes = 'rgba(232, 90, 0, 1)'// orange e85a00
        const pretes = 'rgba(239, 185, 7, 1)' // jaune efb907
        //const imprimees = 'rgba(239, 185, 7, 1)' // jaune efb907
        const imprimees = 'rgba(34, 136, 51, 1)' // vert 228833
        const a_faire = 'rgba(39, 79, 221, 1)' // bleu 274fdd

        const ctx = document.getElementById('pie-chart').getContext('2d');
        this.chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Pickées', 'Prêtes', 'Imprimées', 'À faires'],
            datasets: [{
            label: 'Lignes',
            data: [ 0, 0, 0, 0, 0, 0],
            backgroundColor: [
                //restantes,
                pickees, 
                pretes,
                imprimees, 
                a_faire],
            borderColor: '#ffffff',
            borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            scales: {
            r: {
                pointLabels: {
                display: true,
                centerPointLabels: true,
                font: {
                    size: 18
                }
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
            },
            x:{
                display: true,
                title: {
                    display: true,
                    text: 'Statut',
                    font: {
                        weight: 'bold',
                    },
                }
            }
            },
            plugins: {
            legend: {
                display: false,
                position: 'bottom'
            }
            }
        }
        });
    },

    convertData(data) {
        // Update the DOM with the fetched data
        if(typeof data !== 'undefined'){
            //this.chart.data.datasets[0].data[0] = data[0].livrees;
            //this.chart.data.labels[0] = [data[0].livrees,'Livrées'];
            //this.chart.data.datasets[0].data[0] = (data[0].total-data[0].livrees);
            //this.chart.data.labels[0] = [(data[0].total-data[0].livrees),'Restantes'];
            this.chart.data.datasets[0].data[0] = data[0].completees;
            this.chart.data.labels[0] = [data[0].completees,'Pickées'];
            this.chart.data.datasets[0].data[1] = data[0].pretes;
            this.chart.data.labels[1] = [data[0].pretes,'Prêtes'];
            this.chart.data.datasets[0].data[2] = data[0].imprimees;
            this.chart.data.labels[2] = [data[0].imprimees,'Imprimées'];
            this.chart.data.datasets[0].data[3] = data[0].afaire;
            this.chart.data.labels[3] = [data[0].afaire,'À faires'];

            // vérifier le total des lignes, pour adapter le graphique
                const maxTotal = Math.max(//data[0].livrees, 
                    //(data[0].total-data[0].livrees), 
                    data[0].completees,
                    data[0].imprimees,
                    data[0].afaire
                );

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

            this.chart.update()
        }
    },

  };
  export default OrderLinesStatusHook;
  