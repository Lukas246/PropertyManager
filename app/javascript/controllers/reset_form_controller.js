import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    reset() {
        // Vymaže všechna pole ve formuláři
        this.element.reset()

        // Vrátí kurzor do políčka, aby mohl uživatel hned psát dál
        const input = this.element.querySelector('input[type="text"]')
        if (input) input.focus()
    }
}