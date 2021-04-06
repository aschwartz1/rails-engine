require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items).dependent(:destroy) }
    it { should have_many(:invoices).dependent(:destroy) }
    it { should have_many(:invoice_items).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'class methods' do
    describe '::all_limit' do
      it 'returns <limit> merchants' do
        merchants = create_list(:merchant, 10)

        expect(Merchant.all_limit(5).size).to eq(5)
      end

      it 'returns empty array when limit < 1' do
        merchants = create_list(:merchant, 10)

        expect(Merchant.all_limit(0).size).to eq(0)
        expect(Merchant.all_limit(-1).size).to eq(0)
      end

      it 'returns empty array when there are no merchants' do
        expect(Merchant.all_limit(5).size).to eq(0)
      end
    end

    describe '::find_one_by_name' do
      it 'returns merchant with matching name' do
        merchant_a = create(:merchant, name: 'A Merchant')
        merchant_b = create(:merchant, name: 'B Merchant')

        expect(Merchant.find_one_by_name('B Merchant')).to eq(merchant_b)
      end

      it 'search is case insensitive' do
        merchant_a = create(:merchant, name: 'A Merchant')
        merchant_b = create(:merchant, name: 'B Merchant')

        expect(Merchant.find_one_by_name('b merchant')).to eq(merchant_b)
      end

      it 'returns partial matches' do
        turing = create(:merchant, name: 'Turing')
        ring_world = create(:merchant, name: "Zing's Rings")

        expect(Merchant.find_one_by_name('ring')).to eq(turing)
      end

      it 'returns nil if there are no matches' do
        turing = create(:merchant, name: 'Turing')
        ring_world = create(:merchant, name: "Zing's Rings")

        expect(Merchant.find_one_by_name('asdf')).to be_nil
      end
    end
  end

  describe 'instance methods' do
    describe '#total_revenue' do
      it 'counts successful transactions and shipped invoices' do
        merchant = create(:merchant)
        merchant.items << create(:item, unit_price: 10)
        merchant.items << create(:item, unit_price: 5.33)
        invoice1 = create(:invoice, :shipped, merchant_id: merchant.id)
        invoice2 = create(:invoice, :shipped, merchant_id: merchant.id)
        create(:invoice_item, invoice_id: invoice1.id, item_id: merchant.items[0].id, quantity: 5, unit_price: 10)
        create(:invoice_item, invoice_id: invoice2.id, item_id: merchant.items[1].id, quantity: 3, unit_price: 5.33)
        create(:transaction, :success, invoice_id: invoice1.id)
        create(:transaction, :success, invoice_id: invoice2.id)
        # With this setup, merchant should have total revenue of (10*5 + 5*3) = 65.99

        expect(merchant.total_revenue).to eq(65.99)
      end
    end
  end
end
