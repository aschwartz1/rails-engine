require 'rails_helper'

describe 'Get items for merchant request' do
  describe 'structure' do
    it 'main response body contains one key' do
      merchant = create(:merchant)
      get api_v1_merchant_items_path(merchant)

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)

      expect(body.size).to eq(1)
      expect(body).to have_key(:data)
      expect(body[:data]).to be_an(Array)
      expect(body[:data].size).to eq(0)
    end

    it "body[:data] is an array of the merchant's items" do
      merchant = create(:merchant)
      actual_items = create_list(:item, 3, merchant_id: merchant.id)
      create_list(:item, 2)
      get api_v1_merchant_items_path(merchant)

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)
      items = body[:data]

      # Assert that each item representation is correct
      items.each_with_index do |item, i|
        expect(item.keys.size).to eq(3)

        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        expect(item[:id]).to eq(actual_items[i].id.to_s)

        expect(item).to have_key(:type)
        expect(item[:type]).to be_a(String)
        expect(item[:type]).to eq('item')

        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a(Hash)
        expect(item[:attributes].size).to eq(4)

        attributes = item[:attributes]
        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to be_a(String)
        expect(attributes[:name]).to eq(actual_items[i].name)

        expect(attributes).to have_key(:description)
        expect(attributes[:description]).to be_a(String)
        expect(attributes[:description]).to eq(actual_items[i].description)

        expect(attributes).to have_key(:unit_price)
        expect(attributes[:unit_price]).to be_a(Float)
        expect(attributes[:unit_price]).to eq(actual_items[i].unit_price)

        expect(attributes).to have_key(:merchant_id)
        expect(attributes[:merchant_id]).to be_a(Integer)
        expect(attributes[:merchant_id]).to eq(actual_items[i].merchant_id)
      end
    end
  end

  describe 'sad path' do
    it 'returns 404 if given a bad id' do
      get api_v1_merchant_items_path(-1)

      expect(response).to have_http_status(404)
    end
  end
end
