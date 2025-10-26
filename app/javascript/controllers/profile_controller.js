import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "links" ]
    connect() {
        let currentPage = document.querySelector("turbo-frame#profile-pages").dataset.pageId
        console.log(currentPage)
        for(let link of this.linksTargets){
            if(link.id == currentPage){
                this.activeLink = link
                highlight_link(link)
                break;
            }
        }
    }
    highlight(event) {
        remove_hightlight(this.activeLink)
        this.activeLink = event.currentTarget
        highlight_link(this.activeLink)
    }
}

function highlight_link(link) {
    link.classList.add("active")
}

function remove_hightlight(link) {
    link.classList.remove("active")
}
