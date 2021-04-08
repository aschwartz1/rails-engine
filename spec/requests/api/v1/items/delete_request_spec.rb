require 'rails_helper'

describe 'Delete item request' do
  describe 'happy path' do
    it 'deletes item when passed a valid id' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      delete api_v1_item_path(item)
      expect(response).to have_http_status(204)

      expect(Item.exists?(item.id)).to eq(false)
    end

    it 'deletes related invoice_item rows, preserving invoice if invoice has multiple items' do
      merchant = create(:merchant)
      item1 = create(:item, merchant: merchant)
      item2 = create(:item)
      invoice = create(:invoice)
      invoice_item1 = create(:invoice_item, invoice_id: invoice.id, item_id: item1.id)
      invoice_item2 = create(:invoice_item, invoice_id: invoice.id, item_id: item2.id)

      delete api_v1_item_path(item1)
      expect(response).to have_http_status(204)
      expect(Item.exists?(item1.id)).to eq(false)
      expect(InvoiceItem.exists?(invoice_item1.id)).to eq(false)
      expect(Invoice.exists?(invoice.id)).to eq(true)
    end

    it 'deletes invoice if this item was the only on the invoice' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      invoice = create(:invoice)
      invoice_item = create(:invoice_item, invoice_id: invoice.id, item_id: item.id)

      delete api_v1_item_path(item)
      expect(response).to have_http_status(204)
      expect(Item.exists?(item.id)).to eq(false)
      expect(InvoiceItem.exists?(invoice_item.id)).to eq(false)
      expect(Invoice.exists?(invoice.id)).to eq(false)
    end
  end

  describe 'sad path' do
    it 'returns 400 when passed invalid id' do
      delete api_v1_item_path('foo')
      expect(response).to have_http_status(400)
    end
  end
end
