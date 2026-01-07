import { Controller } from "@hotwired/stimulus"
import AirDatepicker from 'air-datepicker'
import localeEn from 'air-datepicker/locale/en' // Import bahasa Inggris

export default class extends Controller {
  connect() {
    const isTime = this.element.dataset.type === "time"

    this.datepicker = new AirDatepicker(this.element, {
      locale: localeEn,
      timepicker: isTime,
      onlyTimepicker: isTime, // Jika hanya ingin memilih jam
      datepicker: !isTime,
      dateFormat: 'dd/MM/yyyy',
      timeFormat: 'HH:mm',
      autoClose: true,
      isMobile: true,
      // Konfigurasi agar sesuai tema minimalis
      classes: 'brutalist-datepicker',
      navTitles: {
        days: '<strong>MMMM</strong> <i>yyyy</i>'
      }
    })
  }

  disconnect() {
    if (this.datepicker) {
      this.datepicker.destroy()
    }
  }
}