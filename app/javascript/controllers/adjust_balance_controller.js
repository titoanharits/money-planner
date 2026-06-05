import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "modal", "amountInput", "zeroCheckbox" ]

  toggleModal(e) {
    if (e) e.preventDefault()
    this.modalTarget.classList.toggle("hidden")
    this.modalTarget.classList.toggle("flex")
  }

  toggleZero(e) {
    if (this.zeroCheckboxTarget.checked) {
      this.amountInputTarget.disabled = true
      this.amountInputTarget.value = "0"
      this.amountInputTarget.classList.add("bg-slate-100", "text-slate-400")
    } else {
      this.amountInputTarget.disabled = false
      this.amountInputTarget.classList.remove("bg-slate-100", "text-slate-400")
      this.amountInputTarget.focus()
    }
  }

  closeOnBackdrop(e) {
    if (e.target === this.modalTarget) {
      this.toggleModal()
    }
  }
}
