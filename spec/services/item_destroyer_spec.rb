require 'rails_helper'

RSpec.describe 'ItemDestroyer' do
  it 'exists' do
    item = create(:item)
    destroyer = ItemDestroyer.new(item.id)

    expect(destroyer).to be_an(ItemDestroyer)
    expect(destroyer.error).to eq('')
  end

  describe 'deleting items' do
    it 'deletes items' do
      item = create(:item)
      destroyer = ItemDestroyer.new(item.id)

      result = destroyer.destroy

      expect(result).to eq(true)
      expect(destroyer.error).to eq('')
      expect(Item.exists?(item.id)).to eq(false)
    end

    it 'leaves invoice alone if invoice still has other items' do
      merchant = create(:merchant)
      item1 = create(:item, merchant: merchant)
      item2 = create(:item)
      invoice = create(:invoice)
      invoice_item1 = create(:invoice_item, invoice_id: invoice.id, item_id: item1.id)
      invoice_item2 = create(:invoice_item, invoice_id: invoice.id, item_id: item2.id)

      destroyer = ItemDestroyer.new(item1.id)
      result = destroyer.destroy

      expect(result).to eq(true)
      expect(destroyer.error).to eq('')
      expect(Item.exists?(item1.id)).to eq(false)
      expect(InvoiceItem.exists?(invoice_item1.id)).to eq(false)
      expect(Invoice.exists?(invoice.id)).to eq(true)
    end

    it 'deletes invoice if deleting item leaves invoice empty' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      invoice = create(:invoice)
      invoice_item = create(:invoice_item, invoice_id: invoice.id, item_id: item.id)

      destroyer = ItemDestroyer.new(item.id)
      result = destroyer.destroy

      expect(result).to eq(true)
      expect(destroyer.error).to eq('')
      expect(Item.exists?(item.id)).to eq(false)
      expect(InvoiceItem.exists?(invoice_item.id)).to eq(false)
      expect(Invoice.exists?(invoice.id)).to eq(false)
    end
  end

  describe 'sad path' do
    it 'returns false and sets error when bad item id is passed in' do
      destroyer = ItemDestroyer.new('foo')
      result = destroyer.destroy

      expect(result).to eq(false)
      expect(destroyer.error).to eq('Invalid item id')
    end
  end
end
