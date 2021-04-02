require 'rails_helper'

describe 'Get all merchants request' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)
    get api_v1_merchants_path

    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(3)
    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(Integer)

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end
  end

  describe 'without optional parameters' do
    it 'defaults to 20 per page' do

    end

    it 'defaults to page 1' do

    end
  end

  describe 'with optional parameters' do
    it 'returns correct number per page when per_page is specified' do

    end

    it 'returns correct page of data when page is specified' do

    end

    it 'correct number and page when per_page and page are specified' do

    end

    it 'returns less than per_page when there are not <per_page> records' do

    end
  end
end
