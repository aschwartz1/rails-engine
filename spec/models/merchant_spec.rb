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
  end
end
