module ApplicationHelper
  def formatted_amount(amount)
    amount >= 0 ? format('$%.2f', amount.to_f) : format('- $%.2f', amount.abs.to_f)
  end
end
