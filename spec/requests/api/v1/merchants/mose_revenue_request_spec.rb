require 'rails_helper'

describe 'Get <x> top merchants based on revenue' do
  describe 'structure' do
    it 'main response body contains one key' do
      get api_v1_merchants_most_revenue_path(quantity: 1)

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)

      expect(body.size).to eq(1)
      expect(body).to have_key(:data)
      expect(body[:data]).to be_an(Array)
      expect(body[:data].size).to eq(0)
    end

    it 'body[:data] is an array of merchants' do
      merchant = create(:merchant)
      get api_v1_merchants_most_revenue_path

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)
      merchants = body[:data]
      actual_merchants = Merchant.all

      # Assert that each merchant representation is correct
      merchants.each_with_index do |merchant, i|
        expect(merchant.keys.size).to eq(3)

        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)
        expect(merchant[:id]).to eq(actual_merchants[i].id.to_s)

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to be_a(String)
        expect(merchant[:type]).to eq('merchant_name_revenue')

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to be_a(Hash)
        expect(merchant[:attributes].size).to eq(2)

        attributes = merchant[:attributes]
        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to be_a(String)
        expect(attributes[:name]).to eq(actual_merchants[i].name)

        expect(attributes).to have_key(:revenue)
        expect(attributes[:revenue]).to be_a(Float)
        expect(attributes[:revenue]).to eq(0)
      end
    end
  end

  describe 'happy path' do
    it 'works' do

    end
  end

  describe 'sad path' do
    xit 'returns error if quantity is missing' do
    end

    xit 'returns error if quantity < 0' do
    end
  end

  def setup_merchants_with_revenue
    merchant_1_with_history
    merchant_2_with_history
    merchant_3_with_history
    merchant_4_with_history
    merchant_5_with_history
    merchant_6_with_history
    merchant_7_with_history
  end

  def merchant_1_with_history
    @merchant_1 = create(:merchant, name: 'Merchant 1')
    customer = create(:customer)
    item = @merchant_1.items.create!(name: 'Item', description: 'foo bar baz quux', unit_price: 10)
    invoice = Invoice.create!(customer_id: customer.id, status: Invoice.statuses[:completed])
    InvoiceItem.create!(invoice_id: invoice.id, item_id: item.id, quantity: 1, unit_price: 10)
    Transaction.create!(invoice_id: invoice.id, result: 'success')
  end

  def merchant_2_with_history
    @merchant_2 = create(:merchant, name: 'Merchant 2')
    customer = create(:customer)
    item = @merchant_2.items.create!(name: 'Item', description: 'foo bar baz quux', unit_price: 10)
    invoice = Invoice.create!(customer_id: customer.id, status: Invoice.statuses[:completed])
    InvoiceItem.create!(invoice_id: invoice.id, item_id: item.id, quantity: 1, unit_price: 20)
    Transaction.create!(invoice_id: invoice.id, result: 'success')
  end

  def merchant_3_with_history
    @merchant_3 = create(:merchant, name: 'Merchant 3')
    customer = create(:customer)
    item = @merchant_3.items.create!(name: 'Item', description: 'foo bar baz quux', unit_price: 20)
    invoice = Invoice.create!(customer_id: customer.id, status: Invoice.statuses[:completed])
    InvoiceItem.create!(invoice_id: invoice.id, item_id: item.id, quantity: 1, unit_price: 30)
    Transaction.create!(invoice_id: invoice.id, result: 'success')
  end

  def merchant_4_with_history
    @merchant_4 = create(:merchant, name: 'Merchant 4')
    customer = create(:customer)
    item_1 = @merchant_4.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 10)
    item_2 = @merchant_4.items.create!(name: 'Item 2', description: 'foo bar baz quux', unit_price: 20)
    invoice_1 = Invoice.create!(customer_id: customer.id, status: Invoice.statuses[:completed])
    invoice_2 = Invoice.create!(customer_id: customer.id, status: Invoice.statuses[:completed])
    InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 1, unit_price: 40)
    InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_2.id, quantity: 1, unit_price: 40)
    # Note first transaction is failed
    Transaction.create!(invoice_id: invoice_1.id, result: 'success')
    Transaction.create!(invoice_id: invoice_2.id, result: 'success')
  end

  def merchant_5_with_history
    @merchant_5 = create(:merchant, name: 'Merchant 5')
    customer = create(:customer)
    item_1 = @merchant_5.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 10)
    item_2 = @merchant_5.items.create!(name: 'Item 2', description: 'foo bar baz quux', unit_price: 20)
    invoice_1 = Invoice.create!(customer_id: customer.id, status: Invoice.statuses[:completed])
    invoice_2 = Invoice.create!(customer_id: customer.id, status: Invoice.statuses[:completed])
    InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 1, unit_price: 50)
    InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_2.id, quantity: 1, unit_price: 50)
    # Note second transaction is failed
    Transaction.create!(invoice_id: invoice_1.id, result: 'success')
    Transaction.create!(invoice_id: invoice_2.id, result: 'success')
  end

  def merchant_6_with_history
    @merchant_6 = create(:merchant, name: 'Merchant 6')
    customer = create(:customer)
    item = @merchant_6.items.create!(name: 'Item', description: 'foo bar baz quux', unit_price: 10)
    invoice = Invoice.create!(customer_id: customer.id, status: Invoice.statuses[:completed])
    InvoiceItem.create!(invoice_id: invoice.id, item_id: item.id, quantity: 1, unit_price: 1)
    Transaction.create!(invoice_id: invoice.id, result: 'success')
  end

  def merchant_7_with_history
    @merchant_7 = create(:merchant, name: 'Merchant 7')
    customer = create(:customer)
    item_1 = @merchant_7.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 10)
    item_2 = @merchant_7.items.create!(name: 'Item 2', description: 'foo bar baz quux', unit_price: 20)
    invoice_1 = Invoice.create!(customer_id: customer.id, status: Invoice.statuses[:completed])
    invoice_2 = Invoice.create!(customer_id: customer.id, status: Invoice.statuses[:completed])
    InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 1, unit_price: 3)
    InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_2.id, quantity: 1, unit_price: 3)
    Transaction.create!(invoice_id: invoice_1.id, result: 'success')
    Transaction.create!(invoice_id: invoice_2.id, result: 'success')
  end
end
