require 'rails_helper'

RSpec.describe 'Factory Bot' do
  it 'can create dummy objects to use for testing' do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = create(:invoice)
    item = create(:item)
    invoice_item = create(:invoice_item)
    transaction = create(:transaction)

    expect(merchant.class).to eq(Merchant)
    expect(invoice.class).to eq(Invoice)
    expect(customer.class).to eq(Customer)
    expect(item.class).to eq(Item)
    expect(invoice_item.class).to eq(InvoiceItem)
    expect(transaction.class).to eq(Transaction)
  end

  it 'invoice traits work' do
    shipped = create(:invoice, :shipped)
    returned = create(:invoice, :returned)
    packaged = create(:invoice, :packaged)

    expect(shipped.status).to eq('shipped')
    expect(returned.status).to eq('returned')
    expect(packaged.status).to eq('packaged')
  end

  it 'transaction traits work' do
    failed = create(:transaction, :failed)
    refunded = create(:transaction, :refunded)
    success = create(:transaction, :success)

    expect(failed.result).to eq('failed')
    expect(refunded.result).to eq('refunded')
    expect(success.result).to eq('success')
  end
end
