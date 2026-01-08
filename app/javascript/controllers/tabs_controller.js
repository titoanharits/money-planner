// app/javascript/controllers/tabs_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  switch(e) {
    const type = e.currentTarget.dataset.type

    // Update Tab UI
    this.tabTargets.forEach(tab => {
      tab.classList.remove('bg-white', 'border-slate-900', 'text-slate-900')
      tab.classList.add('text-slate-400', 'border-transparent')
    })
    e.currentTarget.classList.add('bg-white', 'border-slate-900', 'text-slate-900')
    e.currentTarget.classList.remove('text-slate-400', 'border-transparent')

    // Update Panel visibility
    this.panelTargets.forEach(panel => {
      panel.classList.toggle('hidden', panel.dataset.type !== type)
    })
  }
} 