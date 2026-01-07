module ApplicationHelper
  def format_money(amount)
    unit = current_user.currency == "IDR" ? "Rp " : "#{current_user.currency} "
    number_to_currency(amount, unit: unit, precision: 0, delimiter: ".", separator: ",")
  end
end
