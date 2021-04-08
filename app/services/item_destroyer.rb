class ItemDestroyer
  def self.destroy_consider_invoice(id)
    item = Item.find(id)
    invoices = item.invoices.includes(:invoice_items)

    invoice_ids = item
    require "pry"; binding.pry
    destroy(id)
    require "pry"; binding.pry

    invoices.each do |invoice|
      i = invoice.invoice_items
      require "pry"; binding.pry
      Invoice.destroy(invoice.id) if invoice.invoice_items.empty?
    end
  end
end
