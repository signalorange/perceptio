// assets/js/hooks/order_lines_today_hook.js

const OrderLinesStatusHook = {
    mounted() {
        const livrees = 'rgba(34, 136, 51, 1)' // vert
        const restantes = 'rgba(149, 97, 226, 1)' // mauve
        const pickees = 'rgba(238, 102, 119, 1)' //rose
        const pretes = 'rgba(204, 187, 68, 1)' // jaune
        const imprimees = 'rgba(102, 204, 238, 1)' // bleu pale
        const a_faire = 'rgba(68, 119, 170, 1)' // bleu

        const ctx = document.getElementById('pie-chart').getContext('2d');
        const chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: [ 'Livrées', 'Restantes'],
            datasets: [{
                label: 'Livrées',
                data: [ 0, 0 ],
                backgroundColor: livrees,
                stack: 'Livrées',
                },
                {
                label: 'Pickées',
                data: [ 0, 0],
                backgroundColor: pickees,
                stack: 'Pickées',
                },
                {
                label: 'Prêtes',
                data: [ 0, 0],
                backgroundColor: pretes,
                stack: 'Prêtes',
                },
                {
                label: 'Imprimées',
                data: [ 0, 0],
                backgroundColor: imprimees,
                stack: 'Imprimées',
                },
                {
                label: 'À faires',
                data: [ 0, 0],
                backgroundColor: a_faire,
                stack: 'À faires',
                }]
            },
        options: {
            responsive: true,
            scales: {
                x: {
                    stacked: true,
                    display: true,
                    title: {
                        display: false,
                        text: 'Statut',
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
                display: false,
                position: 'bottom'
            }
            }
        }
        });

      this.fetchData(chart);
      this.timer = setInterval(() => this.fetchData(chart), 5 * 60 * 1000); // 5 minutes interval
    },
  
    destroyed() {
      clearInterval(this.timer);
    },
    
    fetchData(chart) {
    fetch('/api/nb_commandes_ln')
    .then(response => response.json())  // Parse JSON response
    .then(data => {
      // Update the DOM with the fetched data
      if(typeof data[0] !== 'undefined'){
          chart.data.datasets[0].data[0] = data[0].livrees;
          chart.data.labels[0] = [data[0].livrees,'Livrées'];
          //chart.data.datasets[0].data[1] = (data[0].total-data[0].livrees);
          //chart.data.labels[1] = [(data[0].total-data[0].livrees),'Restantes'];
          chart.data.datasets[1].data[1] = data[0].completees;
          //chart.data.labels[1] = [data[0].completees,'Pickées'];
          chart.data.datasets[2].data[1] = data[0].pretes;
          //chart.data.labels[] = [data[0].pretes,'Prêtes'];
          chart.data.datasets[3].data[1] = data[0].imprimees;
          //chart.data.labels[4] = [data[0].imprimees,'Imprimées'];
          chart.data.datasets[4].data[1] = data[0].afaire;
          //chart.data.labels[5] = [data[0].afaire,'À faires'];

          // vérifier le total des lignes, pour adapter le graphique
            const maxTotal = Math.max(data[0].livrees, 
                data[0].completees,
                data[0].imprimees,
                data[0].afaire
            );

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
            chart.options.scales.y.max = yAxisMax;

          chart.update()
      }
    })
    },
  };
  
  export default OrderLinesStatusHook;
  