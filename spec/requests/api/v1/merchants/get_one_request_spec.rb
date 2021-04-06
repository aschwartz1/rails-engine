require 'rails_helper'

describe 'Get one merchants request' do
  describe 'structure' do
    it 'main response body contains one key' do
      merchant = create(:merchant)
      get api_v1_merchant_path(merchant)

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)

      expect(body.size).to eq(1)
      expect(body).to have_key(:data)
      expect(body[:data]).to be_a(Hash)
    end

    it 'body[:data] is a single merchant' do
      merchant = create(:merchant)
      get api_v1_merchant_path(merchant)

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
      expect(merchant_response[:type]).to eq('merchant')

      expect(merchant_response).to have_key(:attributes)
      expect(merchant_response[:attributes]).to be_a(Hash)
      expect(merchant_response[:attributes].size).to eq(1)

      attributes = merchant_response[:attributes]
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
      expect(attributes[:name]).to eq(merchant.name)
    end
  end

  describe 'odd cases' do
    it 'sends 404 when there is no merchant with the suplied id' do
      get api_v1_merchant_path(-1)

      expect(response).to have_http_status(404)
      body = JSON.parse(response.body, symbolize_names: true)
      null_merchant = body[:data]

      expect(null_merchant[:id]).to eq(nil)
      expect(null_merchant[:type]).to eq('merchant')
      expect(null_merchant[:attributes].size).to eq(1)

      attributes = null_merchant[:attributes]
      expect(attributes[:name]).to eq(nil)
    end
  end
end
