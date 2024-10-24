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

import hljs from "highlight.js"

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

// function to update the line numbers
function UpdateLineNumbers(value) {
    const lineNumberText = document.querySelector("#line-numbers")
    // if the element does not exist, return
    if (!lineNumberText) return;
    
    // split the textarea value by new line
    const lines = value.split("\n");

    // create a string of numbers from 1 to the number of lines
    const numbers = lines.map((_, index) => index + 1).join("\n") + "\n"

    // set the text content of the element to the numbers string
    lineNumberText.value = numbers
};

let Hooks = {};

// New hook for highlighting code
Hooks.Highlight = {
    mounted() {
        let name = this.el.getAttribute("data-name");
        let codeBlock = this.el.querySelector("pre code");

        if (name && codeBlock) {
            codeBlock.className = codeBlock.className.replace(/language-\S+/g, "");
            codeBlock.classList.add(`language-${this.getSyntaxType(name)}`);
            trimmed = this.trimCodeBlock(codeBlock);
            hljs.highlightElement(trimmed);
            UpdateLineNumbers(trimmed.textContent);
        }
    },

    getSyntaxType(name) {
        let extension = name.split(".").pop();

        switch (extension) {
            case "txt":
                return "text";

            case "json":
                return "json";

            case "html":
                return "html";

            case "heex":
                return "html";

            case "js":
                return "javascript";

            default:
                return "elixir";
        }
    },

    trimCodeBlock(codeBlock) {
        const lines = codeBlock.textContent.split("\n")

        if (lines.length > 2) {
            lines.shift();
            lines.pop();
        }
        codeBlock.textContent = lines.join("\n")

        return codeBlock
    }
};

// New hook for updating line numbers
Hooks.UpdateLineNumbers = {
    // life cycle method that is triggered when the component is mounted to the DOM
    mounted() {
        const lineNumberText = document.querySelector("#line-numbers")

        // event listener for input event on the textarea
        this.el.addEventListener("input", () => {
            // call the UpdateLineNumbers function
            UpdateLineNumbers(this.el.value)
        })

        // event listener for scroll event on the textarea
        this.el.addEventListener("scroll", () => {
            lineNumberText.scrollTop = this.el.scrollTop
        })

        // event listener for keydown event on the textarea
        // if the key is Tab, it will allow the user to add tab spaces.
        this.el.addEventListener("keydown", (event) => {
            if (event.key == "Tab") {
                event.preventDefault()
                var start = this.el.selectionStart;
                var end = this.el.selectionEnd;
                this.el.value = this.el.value.substring(0, start) + "\t" + this.el.value.substring(end);
                this.el.selectionStart = this.el.selectionEnd = start + 1;
            }
        })

        // event listener for clear-textarea event after creating the gist.
        this.handleEvent("clear-textarea", () => {
            this.el.value = ""
            lineNumberText.value = "1\n"
        })

        // call it when our element is initialized
        UpdateLineNumbers(this.el.value)
    }
};

Hooks.CopyToClipboard = {
    mounted() {
        this.el.addEventListener("click", (event) => {
            const textToCopy = this.el.getAttribute("data-clipboard-gist");
            if (textToCopy) {
                navigator.clipboard.writeText(textToCopy).then(() => {
                    const originalContent = this.el.innerHTML; // Store original SVG content

                    // Change button content to tick and set style
                    this.el.innerHTML = "&#10003;"; 
                    this.el.style.color = "white";
                    this.el.style.fontSize = "1.1rem";

                    // After 3 seconds, restore original content (SVG)
                    setTimeout(() => {
                        this.el.innerHTML = originalContent;
                        this.el.style.color = ""; // Reset color
                        this.el.style.fontSize = ""; // Reset font size
                    }, 3000);
                }).catch((error) => {
                    console.error("Error copying text: ", error);
                });
            }
        });
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

