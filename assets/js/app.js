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

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

let Hooks = {};

// New hook for updating line numbers
Hooks.UpdateLineNumbers = {
    // life cycle method that is triggered when the component is mounted to the DOM
    mounted() {
        // event listener for input event on the textarea
        this.el.addEventListener("input", () => {
            // call the UpdateLineNumbers function
            this.UpdateLineNumbers()
        })

        // event listener for scroll event on the textarea
        this.el.addEventListener("scroll", () => {
            const lineNumberText = document.querySelector("#line-numbers")
            lineNumberText.scrollTop = this.el.scrollTop
        })
        // call it when our element is initialized
        this.UpdateLineNumbers()
    },

    // function to update the line numbers
    UpdateLineNumbers() {
        const lineNumberText = document.querySelector("#line-numbers")
        // if the element does not exist, return
        if (!lineNumberText) return;
        
        // split the textarea value by new line
        const lines = this.el.value.split("\n");

        // create a string of numbers from 1 to the number of lines
        const numbers = lines.map((_, index) => index + 1).join("\n") + "\n"

        // set the text content of the element to the numbers string
        lineNumberText.value = numbers
    }
};

let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

