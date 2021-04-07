require 'rails_helper'

describe 'Get one item request' do
  describe 'structure' do
    it 'main response body contains one key' do
      item = create(:item)
      get api_v1_item_path(item)

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)

      expect(body.size).to eq(1)
      expect(body).to have_key(:data)
      expect(body[:data]).to be_a(Hash)
    end

    it 'body[:data] is a single item' do
      item = create(:item)
      get api_v1_item_path(item)

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)
      item_response = body[:data]

      # Assert that the item representation is correct
      expect(item_response.size).to eq(3)

      expect(item_response).to have_key(:id)
      expect(item_response[:id]).to be_a(String)
      expect(item_response[:id]).to eq(item.id.to_s)

      expect(item_response).to have_key(:type)
      expect(item_response[:type]).to be_a(String)
      expect(item_response[:type]).to eq('item')

      expect(item_response).to have_key(:attributes)
      expect(item_response[:attributes]).to be_a(Hash)
      expect(item_response[:attributes].size).to eq(4)

      attributes = item_response[:attributes]
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
      expect(attributes[:name]).to eq(item.name)


      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)
      expect(attributes[:description]).to eq(item.description)

      expect(attributes).to have_key(:unit_price)
      expect(attributes[:unit_price]).to be_a(Float)
      expect(attributes[:unit_price]).to eq(item.unit_price)

      expect(attributes).to have_key(:merchant_id)
      expect(attributes[:merchant_id]).to be_a(Integer)
      expect(attributes[:merchant_id]).to eq(item.merchant_id)
    end
  end

  describe 'odd cases' do
    it 'sends 404 when there is no item with the suplied id' do
      get api_v1_item_path(-1)

      expect(response).to have_http_status(404)
      body = JSON.parse(response.body, symbolize_names: true)
      null_item = body[:data]

      expect(null_item[:id]).to eq(nil)
      expect(null_item[:type]).to eq('item')
      expect(null_item[:attributes].size).to eq(4)

      attributes = null_item[:attributes]
      expect(attributes[:name]).to eq(nil)
      expect(attributes[:description]).to eq(nil)
      expect(attributes[:unit_price]).to eq(nil)
      expect(attributes[:merchant_id]).to eq(nil)
    end
  end
end
