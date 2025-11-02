import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "submit", "input", "uploadButton" ]
    connect() {
        this.submitTarget.disabled = true
    }

    toggleButtonText(event) {
        let text = event.currentTarget.value

        if (text == "") {
            this.submitTarget.disabled = true
            this.submitTarget.classList.remove("active-button")
        } else {
            this.submitTarget.disabled = false
            this.submitTarget.classList.add("active-button")
        }
    }

    toggleButtonFile(event) {
        const file = Array.from(event.currentTarget.files)

        if (file[0]) {
            this.submitTarget.disabled = false
            this.inputTarget.disabled = true
            this.submitTarget.classList.add("active-button")
            this.inputTarget.value = ""
            this.inputTarget.placeholder = "Image Post"
            remove_if_image_present(this.inputTarget)
            display_image(file[0], this.inputTarget)
        } else {
            this.submitTarget.disabled = true
            this.inputTarget.disabled = false
            this.submitTarget.classList.remove("active-button")
            this.inputTarget.placeholder = "What's happening?"
            remove_image(this.inputTarget)
        }

    }
}

function display_image(img, target) {
    let image = document.createElement("img")
    image.src = URL.createObjectURL(img);
    image.width = 500;
    
    let parent = target.parentNode

    parent.insertBefore(image, target.nextSibling)
}

function remove_image(target) {
    target.nextElementSibling.remove()
}

function remove_if_image_present(target) {
     if (target.nextElementSibling.nodeName == "IMG") {
        remove_image(target)
     }
}
