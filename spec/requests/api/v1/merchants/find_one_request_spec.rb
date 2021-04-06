require 'rails_helper'

describe 'Find one merchant request' do
  describe 'structure' do
    it 'main response body contains one key' do
      merchant = create(:merchant)
      get api_v1_merchants_find_one_path(name: merchant.name)

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)

      expect(body.size).to eq(1)
      expect(body).to have_key(:data)
      expect(body[:data]).to be_a(Hash)
    end

    it 'body[:data] is a single merchant' do
      merchant = create(:merchant)
      get api_v1_merchants_find_one_path(name: merchant.name)

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

  describe 'sad path' do
    describe 'bad request' do
      it 'returns error response if no value is given for name query param' do
        get "#{api_v1_merchants_find_one_path}?name="

        expect(response).to have_http_status(400)
        body = JSON.parse(response.body, symbolize_names: true)

        expect(body).to be_a(Hash)
        expect(body.size).to eq(2)

        expect(body).to have_key(:code)
        expect(body[:code]).to eq(400)

        expect(body).to have_key(:status)
        expect(body[:status]).to eq('Invalid Query Parameter')
      end

      it 'returns error response if no query param is given at all' do
        get "#{api_v1_merchants_find_one_path}"

        expect(response).to have_http_status(400)
        body = JSON.parse(response.body, symbolize_names: true)

        expect(body).to be_a(Hash)
        expect(body.size).to eq(2)

        expect(body).to have_key(:code)
        expect(body[:code]).to eq(400)

        expect(body).to have_key(:status)
        expect(body[:status]).to eq('Invalid Query Parameter')
      end
    end
  end
end
