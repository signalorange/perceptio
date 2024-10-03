// assets/js/hooks/order_lines_today_hook.js

const OrderLinesTypesHook = {
    mounted() {
        const rouge = 'rgba(232, 0, 0, 1)'
        const orange = 'rgba(255, 143, 0, 1)'
        const bleu = 'rgba(24, 134, 224, 1)'
        const vert = 'rgba(76, 175, 80, 1)'
        const mauve = 'rgba(149, 97, 226, 1)'
        // Stacked chart for Lignes de câbles
        const typesCtx = document.getElementById('cable-chart').getContext('2d');
        const types = new Chart(typesCtx, {
            type: 'bar',
            data: {
            labels: ['Produits en tablette', 'Produits câbles', 'Produits extérieurs'],
            datasets: [
                {
                label: 'Pickées',
                data: [0, 0, 0],
                backgroundColor: bleu,
                //stack: 'Pickées',
                borderWidth: 1,
                borderColor: 'white',
                borderWidth: {
                    top: 1,
                }
                },
                {
                label: 'Imprimées',
                data: [0, 0, 0],
                backgroundColor: orange,
                //stack: 'Imprimées',
                borderWidth: 1,
                borderColor: 'white',
                borderWidth: {
                    top: 1,
                }
                },
                {
                label: 'À faire',
                data: [0, 0, 0],
                backgroundColor: rouge,
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
      this.fetchData(types);
      this.timer = setInterval(() => this.fetchData(types), 5 * 60 * 1000); // 5 minutes interval
    },
  
    destroyed() {
      clearInterval(this.timer);
    },
  
    fetchData(types) {
      // chart par types
    fetch('/api/nb_commandes_ln_types')
        .then(response => response.json())  // Parse JSON response
        .then(data => {
        // Update the DOM with the fetched data

        let stocks = data.findIndex(item => item.type === 0);
        let cables = data.findIndex(item => item.type === 1);
        let exts = data.findIndex(item => item.type === 2);
        let total_stocks = 0;
        let total_cables = 0;
        let total_exts = 0;
        
        if(typeof data[stocks] !== 'undefined' && stocks !== -1){
            types.data.datasets[0].data[0] = data[stocks].completees;
            types.data.datasets[1].data[0] = data[stocks].imprimees;
            types.data.datasets[2].data[0] = data[stocks].afaire;
            total_stocks = data[stocks].completees+data[stocks].imprimees+data[stocks].afaire;
            types.data.labels[0] = [total_stocks,'Produits en tablette'];
        }
        
        if(typeof data[cables] !== 'undefined' && cables !== -1){
            types.data.datasets[0].data[1] = data[cables].completees;
            types.data.datasets[1].data[1] = data[cables].imprimees;
            types.data.datasets[2].data[1] = data[cables].afaire;
            total_cables = data[cables].completees+data[cables].imprimees+data[cables].afaire;
            types.data.labels[1] = [total_cables,'Produits câbles'];
        }

        if(typeof data[exts] !== 'undefined' && exts !== -1){
            types.data.datasets[0].data[2] = data[exts].completees;
            types.data.datasets[1].data[2] = data[exts].imprimees;
            types.data.datasets[2].data[2] = data[exts].afaire;
            total_exts = data[exts].completees+data[exts].imprimees+data[exts].afaire;
            types.data.labels[2] = [total_exts,'Produits extérieurs'];
        }

        // vérifier le total des lignes, pour adapter le graphique
        const maxTotal = Math.max(total_stocks, total_cables, total_exts);

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
        types.options.scales.y.max = yAxisMax;


        //types.data.datasets[0].data[2] = data.value;
        types.update()
        })
    },
  
  };
  
  export default OrderLinesTypesHook;
  