// assets/js/hooks/order_lines_today_hook.js

const HourlyTrendHook = {
    mounted() {
        this.initChart()
        const chartDataLive = JSON.parse(this.el.dataset.chart_live)
        const chartDataToday = JSON.parse(this.el.dataset.chart_today)
        const chartDataWeek = JSON.parse(this.el.dataset.chart_week)
        this.convertData(chartDataLive, chartDataToday, chartDataWeek);
    },

    updated() {
        //console.log("update received, order_lines_status", newData);
        const chartDataLive = JSON.parse(this.el.dataset.chart_live)
        const chartDataToday = JSON.parse(this.el.dataset.chart_today)
        const chartDataWeek = JSON.parse(this.el.dataset.chart_week)
        this.convertData(chartDataLive, chartDataToday, chartDataWeek);
    },

    initChart(){
        const mauve = 'rgba(149, 97, 226, 1)'
        // Line chart for trend
        const trendCtx = document.getElementById('trend-chart').getContext('2d');
        const labels = ['05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '00', '01', '02', '03', '04']
        this.chart = new Chart(trendCtx, {
            type: 'line',
            data: {
            labels: labels,
            datasets: [
                {
                label: 'Moyenne 14 jours (lignes restantes)',
                data: Array(labels.length).fill(0),
                borderColor: 'rgba(96, 125, 139, 0.5)',
                borderDash: [5, 5],
                fill: false,
                cubicInterpolationMode: 'monotone',
                tension: 0.4
                },
                //{
                //  label: "Total",
                //  data: Array(labels.length).fill(0),
                //  borderColor: 'rgba(149, 97, 226, 1)',
                //  fill: false,
                //  cubicInterpolationMode: 'monotone',
                //  tension: 0.4
                //},
                {
                label: "Restantes",
                data: Array(labels.length).fill(0),
                borderColor: mauve,
                fill: false,
                cubicInterpolationMode: 'monotone',
                tension: 0.4
                }
                
            ]
            },
            options: {
            responsive: true,
            scales: {
                y: {
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
                        stepSize: 50
                        }
                //type: 'logarithmic',
                },
                x:{
                display: true,
                title: {
                    display: true,
                    text: 'Heure du jour',
                    font: {
                        weight: 'bold',
                    },
                }
                }
            },
            plugins: {
                legend: {
                    display: true,
                    position: 'bottom'
                }
            }
            
            }
        })
    },

    convertData(live, today, week) {
        const labels = ['05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '00', '01', '02', '03', '04']
        
        const updatedData = Array(labels.length).fill(null);
        const now = new Date();
        let hour = now.getHours();
        const minutes = now.getMinutes();

        // Round to nearest hour
        if (minutes >= 30) {
        hour = (hour + 1) % 24; // Increment hour and handle 24-hour overflow
        }

        // Format the hour as a two-digit string
        const roundedHour = hour.toString().padStart(2, '0');

        // Now you can match it with the labels
        const roundedHourIndex = labels.indexOf(roundedHour);

        if (roundedHourIndex !== -1) {
            //trends.data.datasets[1].data[roundedHourIndex] = data[0].total;
            // Map the API data to the correct label index
            week.forEach(item => {
                const labelIndex = labels.indexOf(item.heure); // Find the index of the hour in the labels
                if ((labelIndex !== -1) && (labelIndex <= roundedHourIndex)) {
                    updatedData[labelIndex] = (item.total - item.livrees); // Update the corresponding index with the new total
                }
                });
            this.chart.data.datasets[0].data = updatedData;
            this.chart.update()
        } 

        // Update the DOM with the fetched data
        //const total = Array(labels.length).fill(null);
        const restantes = Array(labels.length).fill(null);
        //const livrees = Array(labels.length).fill(null);
        //const completees = Array(labels.length).fill(null);
        //const imprimees = Array(labels.length).fill(null);
        //const afaire = Array(labels.length).fill(null);
        // Map the API data to the correct label index
        today.forEach(item => {
            const labelIndex = labels.indexOf(item.heure); // Find the index of the hour in the labels
            if (labelIndex !== -1) {
                //total[labelIndex] = item.total; // Update the corresponding index with the new total
                restantes[labelIndex] = item.total -  item.livrees;
                //livrees[labelIndex] = item.livrees;
                //completees[labelIndex] = item.completees;
                //imprimees[labelIndex] = item.imprimees;
                //afaire[labelIndex] = item.afaire;
            }
        });
          //trends.data.datasets[1].data = total;
          this.chart.data.datasets[1].data = restantes;
          // ajoute la valeur live
          this.chart.data.datasets[1].data[roundedHourIndex] = (live[0].total -  live[0].livrees);
          //trends.data.datasets[2].data = livrees;
          //trends.data.datasets[3].data = completees;
          //trends.data.datasets[4].data = imprimees;
          //trends.data.datasets[5].data = afaire;
          this.chart.update()
    },
  };
  
  export default HourlyTrendHook;
  