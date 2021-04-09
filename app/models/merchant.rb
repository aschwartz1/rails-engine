class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :invoice_items, through: :invoices
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def self.all_limit(limit)
    return [] if limit < 1

    Merchant.all.limit(limit)
  end

  def self.find_one_by_name(search_fragment)
    find_by('LOWER(name) LIKE ?', "%#{search_fragment.downcase}%")
  end

  def self.top_by_revenue(limit)
    # rubocop:disable Style/SymbolArray
    joins(invoices: [:invoice_items, :transactions])
      .select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price)')
      .where("transactions.result = 'success' AND invoices.status = 'shipped'")
      .group(:id)
      .order('SUM(invoice_items.quantity * invoice_items.unit_price) DESC')
      .limit(limit)
    # rubocop:enable Style/SymbolArray
  end

  def total_revenue
    invoices
      .joins(:invoice_items, :transactions)
      .where("transactions.result = 'success' AND invoices.status = 'shipped'")
      .sum('invoice_items.quantity * invoice_items.unit_price')
      .to_f
  end
end
