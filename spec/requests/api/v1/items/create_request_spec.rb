require 'rails_helper'

describe 'Create item request' do
  describe 'happy path' do
    it 'Saves the new record' do
      # Create info to send along w/ request
      merchant = create(:merchant)
      headers = {'CONTENT_TYPE' => 'application/json'}
      new_item_data = {
        name: 'new_item',
        description: 'it is neat',
        unit_price: 11.99,
        merchant_id: merchant.id
      }

      post api_v1_items_path, headers: headers, params: JSON.generate(item: new_item_data)
      expect(response).to be_successful

      created_item = Item.last
      expect(created_item.name).to eq('new_item')
      expect(created_item.description).to eq('it is neat')
      expect(created_item.unit_price).to eq(11.99)
      expect(created_item.merchant_id).to eq(merchant.id)
    end

    it 'returns an item representation' do
      # Create info to send along w/ request
      merchant = create(:merchant)
      headers = {'CONTENT_TYPE' => 'application/json'}
      new_item_data = {
        name: 'new_item',
        description: 'it is neat',
        unit_price: 11.99,
        merchant_id: merchant.id
      }

      post api_v1_items_path, headers: headers, params: JSON.generate(item: new_item_data)
      expect(response).to be_successful
      created_item = Item.last
      body = JSON.parse(response.body, symbolize_names: true)
      item_response = body[:data]

      # Assert that the item representation is correct
      expect(item_response.size).to eq(3)
      expect(item_response[:id]).to eq(created_item.id.to_s)
      expect(item_response[:type]).to eq('item')
      expect(item_response[:attributes].size).to eq(4)

      attributes = item_response[:attributes]
      expect(attributes[:name]).to eq('new_item')
      expect(attributes[:description]).to eq('it is neat')
      expect(attributes[:unit_price]).to eq(11.99)
      expect(attributes[:merchant_id]).to eq(merchant.id)
    end
  end

  describe 'sad path' do
    it 'sad path, returns error response if something fails' do
      merchant = create(:merchant)
      headers = {'CONTENT_TYPE' => 'application/json'}
      new_item_data = {
        description: 'it is neat',
        unit_price: 11.99,
        merchant_id: merchant.id
      }

      post api_v1_items_path, headers: headers, params: JSON.generate(item: new_item_data)
      expect(response).to have_http_status(400)
    end

    it 'sad path, save fails for some reason' do
      merchant = create(:merchant)
      headers = {'CONTENT_TYPE' => 'application/json'}
      new_item_data = {
        name: 'new_item',
        description: 'it is neat',
        unit_price: 11.99,
        merchant_id: merchant.id
      }

      # Override the save, so it fails
      allow_any_instance_of(Item).to receive(:save).and_return(nil)

      post api_v1_items_path, headers: headers, params: JSON.generate(item: new_item_data)
      expect(response).to have_http_status(500)
    end
  end
end
