import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
  connect() {
    this.select = new TomSelect(this.element, {
      plugins: ['dropdown_input'],
      create: false,
      sortField: {
        field: "$order"
      }
    })
  }

  disconnect() {
    if (this.select) {
      this.select.destroy()
    }
  }
}
