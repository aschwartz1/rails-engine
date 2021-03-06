require 'rails_helper'

describe 'Merchant total revenue request' do
  describe 'structure' do
    it 'main response body contains one key' do
      merchant = create(:merchant)
      get api_v1_revenue_merchant_path(merchant)

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)

      expect(body.size).to eq(1)
      expect(body).to have_key(:data)
      expect(body[:data]).to be_a(Hash)
    end

    it 'body[:data] is a merchant_revenue' do
      merchant = create(:merchant)
      get api_v1_revenue_merchant_path(merchant)

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)
      merchant_response = body[:data]

      # Assert that the merchant representation is correct
      expect(merchant_response.size).to eq(3)

      expect(merchant_response).to have_key(:id)
      expect(merchant_response[:id]).to be_a(String)
      expect(merchant_response[:id]).to eq(merchant.id.to_s)

      expect(merchant_response).to have_key(:type)
      expect(merchant_response[:type]).to be_a(String)
      expect(merchant_response[:type]).to eq('merchant_revenue')

      expect(merchant_response).to have_key(:attributes)
      expect(merchant_response[:attributes]).to be_a(Hash)
      expect(merchant_response[:attributes].size).to eq(1)

      attributes = merchant_response[:attributes]
      expect(attributes).to have_key(:revenue)
      expect(attributes[:revenue]).to be_a(Float)
      expect(attributes[:revenue]).to eq(merchant.total_revenue)
    end
  end

  describe 'response data' do
    it 'returns correct merchant and revenue' do
      merchant_with_65_99_total_revenue
      get api_v1_revenue_merchant_path(@merchant)

      body = JSON.parse(response.body, symbolize_names: true)
      revenue_data = body[:data]

      expect(revenue_data[:id]).to eq(@merchant.id.to_s)
      expect(revenue_data[:attributes][:revenue]).to eq(65.99)
    end
  end

  describe 'sad path' do
    it 'returns 404 when merchant is not found' do
      get api_v1_revenue_merchant_path(-1)

      body = JSON.parse(response.body, symbolize_names: true)
      data = body[:data]

      expect(response).to have_http_status(404)
      expect(data[:id]).to be_nil
      expect(data[:attributes][:revenue]).to be_nil
    end
  end
end
