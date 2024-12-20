// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

// assets/js/app.js

import OrderLinesTodayHook from "./hooks/order_lines_today"
import HourlyTrendHook from "./hooks/hourly_trend"
import OrderLinesStatusHook from "./hooks/order_lines_status"
import OrderLinesTypesHook from "./hooks/order_lines_types";
import OrderLinesRoutesHook from "./hooks/order_lines_routes"
import MapboxInteraction from "./hooks/map_live";

let Hooks = {
    OrderLinesToday: OrderLinesTodayHook,
    HourlyTrend: HourlyTrendHook,
    OrderLinesStatus: OrderLinesStatusHook,
    OrderLinesTypes: OrderLinesTypesHook,
    OrderLinesRoutes: OrderLinesRoutesHook,
    MapboxInteraction: MapboxInteraction,
  // ... other hooks
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  hooks: Hooks,
  params: {_csrf_token: csrfToken}
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#DE9043"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

