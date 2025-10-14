import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "links" ]

    connect() {
        let currentPage = document.querySelector("#page-id").value
        this.svgValues = { 
            "posts-link-active": "M12,3L20,9V21H15V14H9V21H4V9L12,3Z",
            "users-link-active": "M16 17V19H2V17S2 13 9 13 16 17 16 17M12.5 7.5A3.5 3.5 0 1 0 9 11A3.5 3.5 0 0 0 12.5 7.5M15.94 13A5.32 5.32 0 0 1 18 17V19H22V17S22 13.37 15.94 13M15 4A3.39 3.39 0 0 0 13.07 4.59A5 5 0 0 1 13.07 10.41A3.39 3.39 0 0 0 15 11A3.5 3.5 0 0 0 15 4Z",
            "profile-link-active": "M12,4A4,4 0 0,1 16,8A4,4 0 0,1 12,12A4,4 0 0,1 8,8A4,4 0 0,1 12,4M12,14C16.42,14 20,15.79 20,18V20H4V18C4,15.79 7.58,14 12,14Z",
            "follow-requests-link-active": "M21,19V20H3V19L5,17V11C5,7.9 7.03,5.17 10,4.29C10,4.19 10,4.1 10,4A2,2 0 0,1 12,2A2,2 0 0,1 14,4C14,4.1 14,4.19 14,4.29C16.97,5.17 19,7.9 19,11V17L21,19M14,21A2,2 0 0,1 12,23A2,2 0 0,1 10,21",
            "posts-link": "M9,13H15V19H18V10L12,5.5L6,10V19H9V13M4,21V9L12,3L20,9V21H4Z",
            "profile-link": "M12,4A4,4 0 0,1 16,8A4,4 0 0,1 12,12A4,4 0 0,1 8,8A4,4 0 0,1 12,4M12,6A2,2 0 0,0 10,8A2,2 0 0,0 12,10A2,2 0 0,0 14,8A2,2 0 0,0 12,6M12,13C14.67,13 20,14.33 20,17V20H4V17C4,14.33 9.33,13 12,13M12,14.9C9.03,14.9 5.9,16.36 5.9,17V18.1H18.1V17C18.1,16.36 14.97,14.9 12,14.9Z",
            "users-link": "M13.07 10.41A5 5 0 0 0 13.07 4.59A3.39 3.39 0 0 1 15 4A3.5 3.5 0 0 1 15 11A3.39 3.39 0 0 1 13.07 10.41M5.5 7.5A3.5 3.5 0 1 1 9 11A3.5 3.5 0 0 1 5.5 7.5M7.5 7.5A1.5 1.5 0 1 0 9 6A1.5 1.5 0 0 0 7.5 7.5M16 17V19H2V17S2 13 9 13 16 17 16 17M14 17C13.86 16.22 12.67 15 9 15S4.07 16.31 4 17M15.95 13A5.32 5.32 0 0 1 18 17V19H22V17S22 13.37 15.94 13Z",
            "follow-requests-link": "M10 21H14C14 22.1 13.1 23 12 23S10 22.1 10 21M21 19V20H3V19L5 17V11C5 7.9 7 5.2 10 4.3V4C10 2.9 10.9 2 12 2S14 2.9 14 4V4.3C17 5.2 19 7.9 19 11V17L21 19M17 11C17 8.2 14.8 6 12 6S7 8.2 7 11V18H17V11Z"
        }

        for(let link of this.linksTargets){
            if(link.id == currentPage){
                this.activeLink = link
                highlight_link(link, this.svgValues)
                break;
            }
        }
    }

    highlight(event){
        remove_highlight(this.activeLink, this.svgValues)
        let target = event.currentTarget

        if (target.id == "logo-link") {
            this.activeLink = target.nextElementSibling
        } else {
            this.activeLink = target
        }

        highlight_link(this.activeLink, this.svgValues)
    }
}

function highlight_link(link, svgValues) {
    link.classList.add("active")
    update_svg_path_value(link, svgValues[link.id + "-active"])
}

function remove_highlight(link, svgValues) {
    link.classList.remove("active")
    update_svg_path_value(link, svgValues[link.id])
}

function update_svg_path_value(link, value) {
    let svg = link.querySelector("path")
    svg.setAttribute("d", value)
}
