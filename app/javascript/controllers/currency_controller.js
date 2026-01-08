import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "hidden"]

  handleInput(e) {
    // 1. Ambil nilai mentah (hanya angka)
    let rawValue = e.target.value.replace(/\D/g, "")

    // 2. Jika input kosong, bersihkan semua field
    if (rawValue === "") {
      this.hiddenTarget.value = ""
      e.target.value = ""
      return
    }

    // 3. Update hidden field untuk dikirim ke database Rails
    this.hiddenTarget.value = rawValue

    // 4. FORMAT ULANG INPUT YANG SEDANG DIKETIK
    // Ini yang memastikan 1000 langsung berubah jadi 1.000 di layar
    e.target.value = new Intl.NumberFormat("id-ID").format(rawValue)
  }
}