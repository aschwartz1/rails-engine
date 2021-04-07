require 'rails_helper'

describe 'Update item request' do
  describe 'happy path' do
    it 'Updates the new record' do
      # Create info to send along w/ request
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      headers = {'CONTENT_TYPE' => 'application/json'}
      update_item_data = {
        name: 'updated name',
        unit_price: 1,
      }

      patch api_v1_item_path(item), headers: headers, params: JSON.generate(item: update_item_data)
      expect(response).to be_successful

      updated_item = Item.find(item.id)
      expect(updated_item.name).to eq('updated name')
      expect(updated_item.description).to eq(item.description)
      expect(updated_item.unit_price).to eq(1)
      expect(updated_item.merchant_id).to eq(merchant.id)
    end

    it 'returns an item representation' do
      # Create info to send along w/ request
      merchant = create(:merchant)
      item = create(:item)
      headers = {'CONTENT_TYPE' => 'application/json'}
      update_item_data = {
        name: 'updated_name',
        unit_price: 1,
      }

      patch api_v1_item_path(item), headers: headers, params: JSON.generate(item: update_item_data)
      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)
      item_response = body[:data]

      # Assert that the item representation is correct
      updated_item = Item.find(item.id)
      expect(item_response.size).to eq(3)
      expect(item_response[:id]).to eq(updated_item.id.to_s)
      expect(item_response[:type]).to eq('item')
      expect(item_response[:attributes].size).to eq(4)

      attributes = item_response[:attributes]
      expect(attributes[:name]).to eq(updated_item.name)
      expect(attributes[:description]).to eq(updated_item.description)
      expect(attributes[:unit_price]).to eq(updated_item.unit_price)
      expect(attributes[:merchant_id]).to eq(updated_item.merchant_id)
    end
  end

  describe 'sad path' do
    it 'string id passed in' do
      merchant = create(:merchant)
      headers = {'CONTENT_TYPE' => 'application/json'}
      update_item_data = {
        description: 'it is neat',
        unit_price: 11.99,
        merchant_id: merchant.id
      }

      patch api_v1_item_path(id: '1'), headers: headers, params: JSON.generate(item: update_item_data)
      expect(response).to have_http_status(404)
    end

    it 'bad id passed in' do
      merchant = create(:merchant)
      headers = {'CONTENT_TYPE' => 'application/json'}
      update_item_data = {
        description: 'it is neat',
        unit_price: 11.99,
        merchant_id: merchant.id
      }

      patch api_v1_item_path(id: -1), headers: headers, params: JSON.generate(item: update_item_data)
      expect(response).to have_http_status(404)
    end

    it 'bad merchant id passed in' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      headers = {'CONTENT_TYPE' => 'application/json'}
      update_item_data = { merchant_id: -1 }

      patch api_v1_item_path(item), headers: headers, params: JSON.generate(item: update_item_data)
    end
  end
end
