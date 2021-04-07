require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:invoice_items).dependent(:destroy) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe 'class methods' do
    describe '::all_limit' do
      it 'returns <limit> items' do
        merchants = create_list(:item, 10)

        expect(Item.all_limit(5).size).to eq(5)
      end

      it 'returns empty array when limit < 1' do
        items = create_list(:item, 10)

        expect(Item.all_limit(0).size).to eq(0)
        expect(Item.all_limit(-1).size).to eq(0)
      end

      it 'returns empty array when there are no merchants' do
        expect(Item.all_limit(5).size).to eq(0)
      end
    end
  end
end
