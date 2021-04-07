require 'rails_helper'

describe 'Get all items request' do
  describe 'structure' do
    it 'main response body contains one key' do
      get api_v1_items_path

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)

      expect(body.size).to eq(1)
      expect(body).to have_key(:data)
      expect(body[:data]).to be_an(Array)
      expect(body[:data].size).to eq(0)
    end

    it 'body[:data] is an array of items' do
      create_list(:item, 5)
      get api_v1_items_path

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)
      items = body[:data]
      actual_items = Item.all

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
        expect(item[:attributes].size).to eq(1)

        attributes = item[:attributes]
        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to be_a(String)
        expect(attributes[:name]).to eq(actual_items[i].name)
      end
    end
  end

  describe 'without optional parameters' do
    it 'defaults to 20 per page' do
      create_list(:merchant, 25)
      get api_v1_merchants_path

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)
      merchants = body[:data]

      expect(merchants.size).to eq(20)
    end

    it 'defaults to page 1' do
      create_list(:merchant, 25)
      get api_v1_merchants_path

      all_merchants = Merchant.all
      expected_first_merchant = all_merchants[0]
      expected_last_merchant = all_merchants[19]

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)
      actual_merchants = body[:data]
      expect(actual_merchants.size).to eq(20)
      expect(actual_merchants.first[:id]).to eq(expected_first_merchant.id.to_s)
      expect(actual_merchants.last[:id]).to eq(expected_last_merchant.id.to_s)
    end
  end

  describe 'with optional parameters' do
    it 'returns correct number per page when per_page is specified' do
      create_list(:merchant, 4)
      get api_v1_merchants_path(per_page: 2)

      all_merchants = Merchant.all
      expected_first_merchant = all_merchants[0]
      expected_last_merchant = all_merchants[1]

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)
      actual_merchants = body[:data]
      expect(actual_merchants.size).to eq(2)
      expect(actual_merchants.first[:id]).to eq(expected_first_merchant.id.to_s)
      expect(actual_merchants.last[:id]).to eq(expected_last_merchant.id.to_s)
    end

    it 'returns correct page of data when page is specified' do
      create_list(:merchant, 40)
      get api_v1_merchants_path(page: 2)

      all_merchants = Merchant.all
      expected_first_merchant = all_merchants[20]
      expected_last_merchant = all_merchants[39]

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)
      actual_merchants = body[:data]
      expect(actual_merchants.size).to eq(20)
      expect(actual_merchants.first[:id]).to eq(expected_first_merchant.id.to_s)
      expect(actual_merchants.last[:id]).to eq(expected_last_merchant.id.to_s)
    end

    it 'correct number and page when per_page and page are specified' do
      create_list(:merchant, 6)
      get api_v1_merchants_path(per_page: 2, page: 2)

      all_merchants = Merchant.all
      expected_first_merchant = all_merchants[2]
      expected_last_merchant = all_merchants[3]

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)
      actual_merchants = body[:data]
      expect(actual_merchants.size).to eq(2)
      expect(actual_merchants.first[:id]).to eq(expected_first_merchant.id.to_s)
      expect(actual_merchants.last[:id]).to eq(expected_last_merchant.id.to_s)
    end

  end

  describe 'odd cases' do
    it 'returns less than per_page when there are not <per_page> records' do
      # Request 10 records, but the 'page' only has 5
      create_list(:merchant, 15)
      get api_v1_merchants_path(per_page: 10, page: 2)

      all_merchants = Merchant.all
      expected_first_merchant = all_merchants[10]
      expected_last_merchant = all_merchants[14]

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)
      actual_merchants = body[:data]
      expect(actual_merchants.size).to eq(5)
      expect(actual_merchants.first[:id]).to eq(expected_first_merchant.id.to_s)
      expect(actual_merchants.last[:id]).to eq(expected_last_merchant.id.to_s)
    end

    it 'sends empty array when there are no merchants' do
      get api_v1_merchants_path

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)
      merchants = body[:data]

      expect(merchants).to be_an(Array)
      expect(merchants.size).to eq(0)
    end

    it 'sends page 1 if page number <= 0' do
      create_list(:merchant, 10)
      get api_v1_merchants_path(page: 0)

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)
      merchants = body[:data]

      expect(merchants).to be_an(Array)
      expect(merchants.size).to eq(10)
    end

    it 'sends empty array when page_number is past the # of pages in the db' do
      # Request page 200 w/ when there are only 10 records in the db
      create_list(:merchant, 10)
      get api_v1_merchants_path(page: 200)

      expect(response).to be_successful
      body = JSON.parse(response.body, symbolize_names: true)
      merchants = body[:data]

      expect(merchants).to be_an(Array)
      expect(merchants.size).to eq(0)
    end
  end
end
