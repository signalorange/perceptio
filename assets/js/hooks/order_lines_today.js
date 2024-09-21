// assets/js/hooks/order_lines_today_hook.js

const OrderLinesTodayHook = {
    mounted() {
      this.fetchData();
      this.timer = setInterval(() => this.fetchData(), 5 * 60 * 1000); // 5 minutes interval
    },
  
    destroyed() {
      clearInterval(this.timer);
    },
  
    fetchData() {
      fetch('/api/nb_commandes_ln')
        .then(response => response.json())
        .then(data => {
          if (typeof data[0] !== 'undefined') {
            this.updateValues(data[0]);
          }
        });
    },
  
    updateValues(data) {
      document.getElementById('comm_today').innerHTML = data.total;
      document.getElementById('comm_livrees').innerHTML = data.livrees;
      document.getElementById('comm_restant').innerHTML = (data.total - data.livrees);
    }
  };
  
  export default OrderLinesTodayHook;
  