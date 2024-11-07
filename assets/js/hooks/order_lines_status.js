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
            labels: [ 'Livrées', 'Restantes', 'Pickées', 'Prêtes', 'Imprimées', 'À faires'],
            datasets: [{
            label: 'Lignes',
            data: [ 0, 0, 0, 0, 0, 0],
            backgroundColor: [
                livrees,
                restantes,
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

      this.fetchData(chart);
      this.timer = setInterval(() => this.fetchData(chart), 5 * 60 * 1000); // 5 minutes interval
    },
  
    destroyed() {
      clearInterval(this.timer);
    },
    
    fetchData(chart) {
        const labels = ['05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '00', '01', '02', '03', '04']
        // chart par types
    fetch('/api/nb_commandes_ln')
    .then(response => response.json())  // Parse JSON response
    .then(data => {
      // Update the DOM with the fetched data
      if(typeof data[0] !== 'undefined'){
          chart.data.datasets[0].data[0] = data[0].livrees;
          chart.data.labels[0] = [data[0].livrees,'Livrées'];
          chart.data.datasets[0].data[1] = (data[0].total-data[0].livrees);
          chart.data.labels[1] = [(data[0].total-data[0].livrees),'Restantes'];
          chart.data.datasets[0].data[2] = data[0].completees;
          chart.data.labels[2] = [data[0].completees,'Pickées'];
          chart.data.datasets[0].data[3] = data[0].pretes;
          chart.data.labels[3] = [data[0].pretes,'Prêtes'];
          chart.data.datasets[0].data[4] = data[0].imprimees;
          chart.data.labels[4] = [data[0].imprimees,'Imprimées'];
          chart.data.datasets[0].data[5] = data[0].afaire;
          chart.data.labels[5] = [data[0].afaire,'À faires'];

          // vérifier le total des lignes, pour adapter le graphique
            const maxTotal = Math.max(data[0].livrees, 
                (data[0].total-data[0].livrees), 
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
  