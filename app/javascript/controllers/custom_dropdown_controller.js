import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["menu", "label", "input"]

    // 1. Otevře/zavře menu
    toggle(event) {
        event.preventDefault()
        this.menuTarget.classList.toggle("d-none")
    }

    // 2. Zavře menu, když klikneš mimo
    hide(event) {
        if (!this.element.contains(event.target)) {
            this.menuTarget.classList.add("d-none")
        }
    }

    // 3. Vybere položku
    select(event) {
        const id = event.currentTarget.dataset.id
        const name = event.currentTarget.dataset.name

        this.inputTarget.value = id      // Zapíše do hidden field
        this.labelTarget.innerText = name // Přepíše text na tlačítku
        this.menuTarget.classList.add("d-none") // Schová menu
    }
}