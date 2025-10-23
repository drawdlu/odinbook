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
            display_image(file[0], this.inputTarget)
        } else {
            console.log("no file")
            this.submitTarget.disabled = true
            this.inputTarget.disabled = false
            this.submitTarget.classList.remove("active-button")
            this.inputTarget.placeholder = "What's happening?"
            remove_image(this.inputTarget)
        }

    }
}

function display_image(img, target) {
    console.log(img)
    let image = document.createElement("img")
    image.src = URL.createObjectURL(img);
    image.width = 500;

    console.log(image)
    
    let parent = target.parentNode

    parent.insertBefore(image, target.nextSibling)
}

function remove_image(target) {
    target.nextElementSibling.remove()
}
