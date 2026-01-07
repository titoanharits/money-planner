class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @start_date = Date.today.beginning_of_month
    @end_date = Date.today.end_of_month

    #Mengambil semua transaksi bulan ini
    transactions = current_user.transactions.where(date: @start_date..@end_date).includes(:category)

    #Kalkulasi Total (Income vs Expense)
    @total_income = transactions.joins(:category).where(categories: { category_type: 1 }).sum(:amount)
    @total_expense = transactions.joins(:category).where(categories: { category_type: 0 }).sum(:amount)
    @net_balance = @total_income - @total_expense

    #financial health
    @health_percent = @total_income > 0 ? ((@total_expense.to_f / @total_income) * 100).to_i : 0
    case @health_percent
    when 0..40
      @health_status = "Excellent"
      @health_color = "bg-emerald-300"
      @health_advice = "Sangat ideal! Anda menyisihkan lebih dari 60% pendapatan. Waktunya memaksimalkan investasi."
    when 41..60
      @health_status = "Healthy"
      @health_color = "bg-sky-300"
      @health_advice = "Kondisi stabil. Pengeluaran Anda terkendali dan masih memiliki ruang napas yang cukup."
    when 61..90
      @health_status = "Warning"
      @health_color = "bg-yellow-300"
      @health_advice = "Hati-hati, pengeluaran mulai mendominasi pendapatan. Evaluasi biaya gaya hidup Anda."
    when 91..100
      @health_status = "Living Edge"
      @health_color = "bg-orange-400"
      @health_advice = "Berbahaya! Anda hidup dari gaji ke gaji. Nyaris tidak ada sisa untuk dana darurat."
    else
      @health_status = "Deficit"
      @health_color = "bg-rose-400"
      @health_advice = "Kritis! Pengeluaran melebihi pemasukan. Segera pangkas pengeluaran atau cari tambahan penghasilan."
    end

    #Transaksi Terakhir
    @recent_transactions = current_user.transactions.recent.limit(5).includes(:category)
  end
end
