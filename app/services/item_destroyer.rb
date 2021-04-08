class ItemDestroyer
  attr_reader :item_id, :error

  def initialize(item_id)
    @item_id = item_id
    @error = ''
  end

  def destroy
    item = Item.find_by(id: @item_id)

    if item
      invoices = item.invoices.preload(:invoice_items)

      # BEGIN Transaction?
      # Delete any invoice which only contained the item we just deleted
      destroy_empty_invoices(invoices)

      # Delete the item (this will also delete invoice_item rows
      Item.destroy(item_id)
      # END Transaction?
    else
      @error = 'Invalid item id'
    end

    @error.empty?
  end

  private

  def destroy_empty_invoices(invoices)
    invoices.each do |invoice|
      invoice.destroy if invoice.invoice_items.count == 1
    end
  end
end
