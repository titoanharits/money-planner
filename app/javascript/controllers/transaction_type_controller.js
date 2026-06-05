import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "tab", "typeInput", "amountCard",
    "sourceField", "destinationField",
    "sourceSelect", "destinationSelect",
    "categorySelect", "expenseOptgroup", "incomeOptgroup", "transferOptgroup"
  ]

  connect() {
    this.updateUI(this.typeInputTarget.value)
    
    // Ensure tomselect is initialized first, or wait for it
    setTimeout(() => {
      if (this.categorySelectTarget.tomselect) {
        // preserve the selected value on init
        const currentValue = this.categorySelectTarget.value
        this.updateTomSelectOptions(this.typeInputTarget.value)
        if (currentValue) this.categorySelectTarget.tomselect.setValue(currentValue, true)
      }
    }, 50)
  }

  switch(event) {
    const type = event.currentTarget.dataset.type
    this.typeInputTarget.value = type
    
    // Reset category on tab switch
    this.categorySelectTarget.value = ""
    if (this.categorySelectTarget.tomselect) {
      this.categorySelectTarget.tomselect.clear()
    }
    
    // Update active tab styling
    this.tabTargets.forEach(tab => {
      if (tab.dataset.type === type) {
        tab.classList.remove("border-transparent", "text-slate-400")
        tab.classList.add("border-slate-900", "bg-white", "text-slate-900")
      } else {
        tab.classList.add("border-transparent", "text-slate-400")
        tab.classList.remove("border-slate-900", "bg-white", "text-slate-900")
      }
    })

    this.updateUI(type)
    this.updateTomSelectOptions(type)
  }

  updateUI(type) {
    // Manage Optgroups visually for fallback
    this.expenseOptgroupTarget.disabled = true
    this.incomeOptgroupTarget.disabled = true
    this.transferOptgroupTarget.disabled = true

    if (type === "expense") {
      this.amountCardTarget.classList.replace("bg-lime-500", "bg-indigo-400")
      this.amountCardTarget.classList.replace("bg-sky-400", "bg-indigo-400")
      
      this.sourceFieldTarget.classList.remove("hidden")
      this.destinationFieldTarget.classList.add("hidden")
      
      this.expenseOptgroupTarget.disabled = false
    } else if (type === "income") {
      this.amountCardTarget.classList.replace("bg-indigo-400", "bg-lime-500")
      this.amountCardTarget.classList.replace("bg-sky-400", "bg-lime-500")
      
      this.sourceFieldTarget.classList.add("hidden")
      this.destinationFieldTarget.classList.remove("hidden")

      this.incomeOptgroupTarget.disabled = false
    } else if (type === "transfer") {
      this.amountCardTarget.classList.replace("bg-indigo-400", "bg-sky-400")
      this.amountCardTarget.classList.replace("bg-lime-500", "bg-sky-400")
      
      this.sourceFieldTarget.classList.remove("hidden")
      this.destinationFieldTarget.classList.remove("hidden")

      this.transferOptgroupTarget.disabled = false
    }
    this.handleCategoryChange()
  }

  updateTomSelectOptions(type) {
    // Sync Tom Select manually to hide disabled options
    if (this.categorySelectTarget.tomselect) {
      const ts = this.categorySelectTarget.tomselect
      ts.clear()
      ts.clearOptions()
      ts.clearOptionGroups()

      const activeOptgroup = type === 'expense' ? this.expenseOptgroupTarget :
                             type === 'income' ? this.incomeOptgroupTarget : 
                             this.transferOptgroupTarget;
                             
      if (activeOptgroup) {
        ts.addOptionGroup(activeOptgroup.label, { label: activeOptgroup.label, value: activeOptgroup.label })
        const options = activeOptgroup.querySelectorAll('option')
        options.forEach(opt => {
          ts.addOption({ value: opt.value, text: opt.text, optgroup: activeOptgroup.label, name: opt.dataset.name })
        })
      }
    }

    this.handleCategoryChange()
  }

  handleCategoryChange() {
    if (this.typeInputTarget.value !== "transfer") return;

    const selectedOption = this.categorySelectTarget.options[this.categorySelectTarget.selectedIndex]
    const isTarikTunai = selectedOption && selectedOption.dataset.name === "Tarik Tunai"

    if (isTarikTunai) {
      this.destinationSelectTarget.disabled = true
      this.destinationSelectTarget.value = ""
      // We will handle the actual assignment in the backend
    } else {
      this.destinationSelectTarget.disabled = false
    }
  }
}
