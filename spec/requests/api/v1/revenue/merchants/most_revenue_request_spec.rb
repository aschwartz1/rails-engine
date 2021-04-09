require 'rails_helper'

describe 'Get <x> top merchants based on revenue' do
  describe 'structure' do
    it 'main response body contains one key' do
      get api_v1_revenue_merchants_path(quantity: 1)

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)

      expect(body.size).to eq(1)
      expect(body).to have_key(:data)
      expect(body[:data]).to be_an(Array)
      expect(body[:data].size).to eq(0)
    end

    it 'body[:data] is the correct array of merchants' do
      setup_merchants_with_revenue
      get api_v1_revenue_merchants_path(quantity: 3)

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)
      merchants = body[:data]
      expect(merchants.size).to eq(3)
      expected_merchants = [@merchant_revenue_50, @merchant_revenue_40, @merchant_revenue_30]

      # Assert that each merchant representation is correct
      merchants.each_with_index do |merchant, i|
        expect(merchant.keys.size).to eq(3)

        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)
        expect(merchant[:id]).to eq(expected_merchants[i].id.to_s)

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to be_a(String)
        expect(merchant[:type]).to eq('merchant_name_revenue')

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to be_a(Hash)
        expect(merchant[:attributes].size).to eq(2)

        attributes = merchant[:attributes]
        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to be_a(String)
        expect(attributes[:name]).to eq(expected_merchants[i].name)

        expect(attributes).to have_key(:revenue)
        expect(attributes[:revenue]).to be_a(Float)
        expect(attributes[:revenue]).to eq(expected_merchants[i].total_revenue)
      end
    end
  end

  describe 'sad path' do
    it 'returns error if quantity is missing' do
      get api_v1_revenue_merchants_path
      expect(response).to have_http_status(400)
    end

    it 'returns error if quantity < 0' do
      get api_v1_revenue_merchants_path(quantity: -1)
      expect(response).to have_http_status(400)
    end
  end
end
