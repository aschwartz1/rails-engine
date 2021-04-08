require 'rails_helper'

RSpec.describe 'Item destroyer' do
  it 'exists' do
    destroyer = ItemDestroyer.new
  end

  describe 'deleting items' do
    it 'deletes items' do

    end

    it 'leaves invoice alone if invoice still has other items' do
      merchant = create(:merchant)
      item1 = create(:item, merchant: merchant)
      item2 = create(:item)
      invoice = create(:invoice)
      invoice_item1 = create(:invoice_item, invoice_id: invoice.id, item_id: item1.id)
      invoice_item2 = create(:invoice_item, invoice_id: invoice.id, item_id: item2.id)

      Item.destroy_consider_invoice(item1.id)

      expect(Item.exists?(item1.id)).to eq(false)
      expect(InvoiceItem.exists?(invoice_item1.id)).to eq(false)
      expect(Invoice.exists?(invoice.id)).to eq(true)
    end

    it 'deletes invoice if deleting item leaves invoice empty' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      invoice = create(:invoice)
      invoice_item = create(:invoice_item, invoice_id: invoice.id, item_id: item.id)

      Item.destroy_consider_invoice(item.id)

      expect(Item.exists?(item.id)).to eq(false)
      expect(InvoiceItem.exists?(invoice_item.id)).to eq(false)
      expect(Invoice.exists?(invoice.id)).to eq(false)
    end
  end
end
