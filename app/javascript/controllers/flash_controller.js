import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Menghilangkan flash secara otomatis setelah 3 detik
    setTimeout(() => {
      this.dismiss()
    }, 3000)
  }

  dismiss() {
    // Menambahkan animasi transisi saat menghilang
    this.element.classList.add("opacity-0", "-translate-y-10", "transition", "duration-500", "ease-in-out")
    
    // Menghapus elemen dari DOM setelah animasi selesai
    setTimeout(() => {
      this.element.remove()
    }, 500)
  }
}