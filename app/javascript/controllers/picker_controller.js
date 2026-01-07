import { Controller } from "@hotwired/stimulus"
import 'emoji-picker-element';

export default class extends Controller {
  static targets = ["iconInput", "iconPreview", "colorInput", "emojiPickerContainer", "budgetContainer"]

  connect() {
    // Menutup picker saat klik di luar area
    this.closePickerOutside = (e) => {
      if (!this.element.contains(e.target)) this.emojiPickerContainerTarget.classList.add('hidden')
    }
    document.addEventListener('click', this.closePickerOutside)
    this.toggleBudget({ target: this.element.querySelector('select[name*="category_type"]') })
  }

  disconnect() {
    document.removeEventListener('click', this.closePickerOutside)
  }

  // Pilih Emoji
  selectEmoji(event) {
    const emoji = event.detail.unicode
    this.iconInputTarget.value = emoji
    this.iconPreviewTarget.innerText = emoji
    this.toggleEmojiPicker()
  }

  // Pilih Warna
  selectColor(event) {
    const color = event.currentTarget.dataset.color
    this.colorInputTarget.value = color
    
    // Reset ring pada semua pilihan warna
    this.element.querySelectorAll('.color-option').forEach(el => {
      el.classList.remove('ring-4', 'ring-blue-500/30', 'scale-110')
    })
    
    // Tambahkan feedback visual pada warna yang dipilih
    event.currentTarget.classList.add('ring-4', 'ring-blue-500/30', 'scale-110')
  }

  toggleBudget(event) {
    const type = event.target.value
    // Jika type adalah 'income', sembunyikan budget container
    if (type === 'income') {
      this.budgetContainerTarget.classList.add('hidden')
    } else {
      this.budgetContainerTarget.classList.remove('hidden')
    }
  }

  toggleEmojiPicker(e) {
    if (e) e.stopPropagation()
    this.emojiPickerContainerTarget.classList.toggle('hidden')
  }
}