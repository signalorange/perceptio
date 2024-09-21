// assets/js/hooks/order_lines_today_hook.js

const OrderLinesStatusHook = {
    mounted() {
        const rouge = 'rgba(232, 0, 0, 1)'
        const orange = 'rgba(255, 143, 0, 1)'
        const bleu = 'rgba(24, 134, 224, 1)'
        const vert = 'rgba(76, 175, 80, 1)'
        const mauve = 'rgba(149, 97, 226, 1)'
        const ctx = document.getElementById('pie-chart').getContext('2d');
        const chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: [ 'Livrées', 'Restantes', 'Pickées', 'Imprimées', 'À faire'],
            datasets: [{
            label: 'Lignes',
            data: [ 0, 0, 0, 0, 0],
            backgroundColor: [
                vert,
                mauve,
                bleu, 
                //'rgba(255, 205, 86, 0.75)', 
                orange, 
                rouge],
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
          chart.data.datasets[0].data[1] = (data[0].total-data[0].livrees);
          chart.data.datasets[0].data[2] = data[0].completees;
          chart.data.datasets[0].data[3] = data[0].imprimees;
          chart.data.datasets[0].data[4] = data[0].afaire;
          chart.update()
      }
    })
    },
  };
  
  export default OrderLinesStatusHook;
  