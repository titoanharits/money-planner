import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["totalIncome", "allocationBar", "allocatedText", "remainingText", "budgetInput"]

  connect() {
    this.currencyFormat = new Intl.NumberFormat('id-ID', {
      style: 'currency',
      currency: 'IDR',
      minimumFractionDigits: 0,
      maximumFractionDigits: 0
    });
    
    // Asumsikan currency dari target pertama, bisa disesuaikan kalau multiple currency
    this.totalIncomeValue = parseFloat(this.totalIncomeTarget.dataset.value) || 0;
    this.calculate();
  }

  calculate() {
    let totalAllocated = 0;

    this.budgetInputTargets.forEach(input => {
      const val = parseFloat(input.value);
      if (!isNaN(val) && val > 0) {
        totalAllocated += val;
      }
    });

    // Update Bar Width
    let percent = 0;
    if (this.totalIncomeValue > 0) {
      percent = (totalAllocated / this.totalIncomeValue) * 100;
      if (percent > 100) percent = 100;
    }
    
    this.allocationBarTarget.style.width = `${percent}%`;

    // Over budget styling
    if (totalAllocated > this.totalIncomeValue) {
      this.allocationBarTarget.classList.remove('bg-lime-300');
      this.allocationBarTarget.classList.add('bg-rose-500');
      this.remainingTextTarget.classList.add('text-rose-400');
      this.remainingTextTarget.classList.remove('text-white');
    } else {
      this.allocationBarTarget.classList.remove('bg-rose-500');
      this.allocationBarTarget.classList.add('bg-lime-300');
      this.remainingTextTarget.classList.remove('text-rose-400');
      this.remainingTextTarget.classList.add('text-white');
    }

    // Format Text
    this.allocatedTextTarget.textContent = `Ter-alokasi: ${this.formatMoney(totalAllocated)}`;
    
    const remaining = this.totalIncomeValue - totalAllocated;
    if (remaining < 0) {
      this.remainingTextTarget.textContent = `Over Budget: ${this.formatMoney(Math.abs(remaining))}`;
    } else {
      this.remainingTextTarget.textContent = `Sisa: ${this.formatMoney(remaining)}`;
    }
  }

  formatMoney(amount) {
    return this.currencyFormat.format(amount).replace('Rp', 'Rp ');
  }
}
