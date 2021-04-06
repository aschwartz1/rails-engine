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

  def total_revenue

  end
end
