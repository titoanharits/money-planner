import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.onScroll()
  }

  onScroll() {
    // Jika posisi scroll lebih dari 10px, tambahkan background & border
    if (window.scrollY > 10) {
      this.element.classList.add("bg-orange-50", "border-b-2", "border-slate-900")
      this.element.classList.remove("py-8")
      this.element.classList.add("py-4") // Membuat header sedikit lebih tipis saat scroll
    } else {
      this.element.classList.remove("bg-orange-50", "border-b-2", "border-slate-900", "py-4")
      this.element.classList.add("py-8")
    }
  }
}