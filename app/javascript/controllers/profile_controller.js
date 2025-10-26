import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "links" ]
    connect() {
        let currentPage = document.querySelector("turbo-frame#profile-pages").dataset.pageId
        for(let link of this.linksTargets){
            if(link.id == currentPage){
                this.activeLink = link
                highlight_link(link, link.lastElementChild)
                break;
            }
        }
    }
    highlight(event) {
        remove_hightlight(this.activeLink, this.activeLink.lastElementChild)
        this.activeLink = event.currentTarget
        highlight_link(this.activeLink, this.activeLink.lastElementChild)
    }
}

function highlight_link(link, border) {
    link.classList.add("active")
    border.classList.add("active")
}

function remove_hightlight(link, border) {
    link.classList.remove("active")
    border.classList.remove("active")
}
