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

        result = Merchant.all_limit(5)
        expect(result.size).to eq(5)
        expect(result.first).to be_a(Merchant)
        expect(result.last).to be_a(Merchant)
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

    describe '::top_by_revenue' do
      it 'shows <limit> merchants in desc revenue order' do
        setup_merchants_with_revenue

        result = Merchant.top_by_revenue(3)
        expect(result).to eq([@merchant_revenue_50, @merchant_revenue_40, @merchant_revenue_30])
      end
    end
  end

  describe 'instance methods' do
    describe '#total_revenue' do
      it 'counts successful transactions and shipped invoices' do
        merchant_with_65_99_total_revenue
        expect(@merchant.total_revenue).to eq(65.99)
      end

      it 'ignores failed transactions and unshipped invoices' do
        merchant_with_65_99_total_revenue_and_disregarded_invoices_and_transactions
        expect(@merchant.total_revenue).to eq(65.99)
      end

      it 'returns 0 when merchant has no invoices at all' do
        merchant = create(:merchant)
        expect(merchant.total_revenue).to eq(0)
      end
    end
  end
end
