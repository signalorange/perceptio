// assets/js/hooks/order_lines_today_hook.js

const OrderLinesTodayHook = {
    mounted() {
        const chartData = JSON.parse(this.el.dataset.chart)
        this.convertData(chartData);
      //this.timer = setInterval(() => this.fetchData(), 5 * 60 * 1000); // 5 minutes interval
    },
    updated() {
        const newData = JSON.parse(this.el.dataset.chart)
        console.log("update received, order_lines_today", newData);
        this.convertData(newData)
      },
  
    convertData(data) {
      document.getElementById('comm_today').innerHTML = data[0].total;
      document.getElementById('comm_livrees').innerHTML = data[0].livrees;
      document.getElementById('comm_restant').innerHTML = (data[0].total - data[0].livrees);
    }
  };
  
  export default OrderLinesTodayHook;
  