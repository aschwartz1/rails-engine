require 'rails_helper'

describe 'Get <x> top merchants based on revenue' do
  describe 'structure' do
    it 'main response body contains one key' do
      get api_v1_merchants_most_revenue_path

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)

      expect(body.size).to eq(1)
      expect(body).to have_key(:data)
      expect(body[:data]).to be_an(Array)
      expect(body[:data].size).to eq(0)
    end

    xit 'body[:data] is an array of merchants' do
      create_list(:merchant, 5)
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
        expect(merchant[:type]).to eq('merchant')

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to be_a(Hash)
        expect(merchant[:attributes].size).to eq(1)

        attributes = merchant[:attributes]
        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to be_a(String)
        expect(attributes[:name]).to eq(actual_merchants[i].name)
      end
    end
  end

  describe 'happy path' do

  end

  describe 'sad path' do
    xit 'returns error if quantity is missing' do
    end

    xit 'returns error if quantity < 0' do
    end
  end
end
