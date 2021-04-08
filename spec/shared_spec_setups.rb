def merchant_with_65_99_total_revenue
  @merchant = create(:merchant)
  @merchant.items << create(:item, unit_price: 10)
  @merchant.items << create(:item, unit_price: 5.33)
  invoice1 = create(:invoice, :shipped, merchant_id: @merchant.id)
  invoice2 = create(:invoice, :shipped, merchant_id: @merchant.id)
  create(:invoice_item, invoice_id: invoice1.id, item_id: @merchant.items[0].id, quantity: 5, unit_price: 10)
  create(:invoice_item, invoice_id: invoice2.id, item_id: @merchant.items[1].id, quantity: 3, unit_price: 5.33)
  create(:transaction, :success, invoice_id: invoice1.id)
  create(:transaction, :success, invoice_id: invoice2.id)
  # With this setup, merchant should have total revenue of (10*5 + 5*3) = 65.99
end

def merchant_with_65_99_total_revenue_and_disregarded_invoices_and_transactions
  @merchant = create(:merchant)
  @merchant.items << create(:item, unit_price: 10)
  @merchant.items << create(:item, unit_price: 5.33)
  invoice1 = create(:invoice, :shipped, merchant_id: @merchant.id)
  invoice2 = create(:invoice, :shipped, merchant_id: @merchant.id)
  invoice3 = create(:invoice, :packaged, merchant_id: @merchant.id)
  invoice4 = create(:invoice, :shipped, merchant_id: @merchant.id)
  invoice5 = create(:invoice, :shipped, merchant_id: @merchant.id)
  create(:invoice_item, invoice_id: invoice1.id, item_id: @merchant.items[0].id, quantity: 5, unit_price: 10)
  create(:invoice_item, invoice_id: invoice2.id, item_id: @merchant.items[1].id, quantity: 3, unit_price: 5.33)
  create(:invoice_item, invoice_id: invoice3.id, item_id: @merchant.items[0].id, quantity: 1, unit_price: 1)
  create(:invoice_item, invoice_id: invoice4.id, item_id: @merchant.items[1].id, quantity: 2, unit_price: 2)
  create(:transaction, :success, invoice_id: invoice1.id)
  create(:transaction, :success, invoice_id: invoice2.id)
  create(:transaction, :success, invoice_id: invoice3.id)
  create(:transaction, :failed, invoice_id: invoice2.id)
  # invoice 5 has no transaction
  # Expect invoice 3, 4, 5 to not be counted in total revenue
end

def setup_merchants_with_revenue
  merchant_revenue_10
  merchant_revenue_20
  merchant_revenue_30
  merchant_revenue_40
  merchant_revenue_50
  merchant_revenue_1
  merchant_revenue_6
end

def merchant_revenue_10
  @merchant_revenue_10 = create(:merchant, name: 'Merchant 1')
  customer = create(:customer)
  item = @merchant_revenue_10.items.create!(name: 'Item', description: 'foo bar baz quux', unit_price: 10)
  item_2 = @merchant_revenue_10.items.create!(name: 'Item 2', description: 'foo bar baz quux', unit_price: 20)
  # Note second invoice is not shipped
  invoice = Invoice.create!(customer_id: customer.id, merchant_id: @merchant_revenue_10.id, status: 'shipped')
  invoice_2 = Invoice.create!(customer_id: customer.id, merchant_id: @merchant_revenue_10.id, status: 'packaged')
  InvoiceItem.create!(invoice_id: invoice.id, item_id: item.id, quantity: 1, unit_price: 10)
  InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_2.id, quantity: 1, unit_price: 50)
  Transaction.create!(invoice_id: invoice.id, result: 'success')
  Transaction.create!(invoice_id: invoice_2.id, result: 'success')
end

def merchant_revenue_20
  @merchant_revenue_20 = create(:merchant, name: 'Merchant 2')
  customer = create(:customer)
  item = @merchant_revenue_20.items.create!(name: 'Item', description: 'foo bar baz quux', unit_price: 10)
  item_2 = @merchant_revenue_20.items.create!(name: 'Item 2', description: 'foo bar baz quux', unit_price: 20)
  invoice = Invoice.create!(customer_id: customer.id, merchant_id: @merchant_revenue_20.id, status: 'shipped')
  invoice_2 = Invoice.create!(customer_id: customer.id, merchant_id: @merchant_revenue_20.id, status: 'shipped')
  InvoiceItem.create!(invoice_id: invoice.id, item_id: item.id, quantity: 1, unit_price: 20)
  InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_2.id, quantity: 1, unit_price: 40)
  # Note second transaction is failed
  Transaction.create!(invoice_id: invoice.id, result: 'success')
  Transaction.create!(invoice_id: invoice_2.id, result: 'failed')
end

def merchant_revenue_30
  @merchant_revenue_30 = create(:merchant, name: 'Merchant 3')
  customer = create(:customer)
  item = @merchant_revenue_30.items.create!(name: 'Item', description: 'foo bar baz quux', unit_price: 20)
  invoice = Invoice.create!(customer_id: customer.id, merchant_id: @merchant_revenue_30.id, status: 'shipped')
  InvoiceItem.create!(invoice_id: invoice.id, item_id: item.id, quantity: 1, unit_price: 30)
  Transaction.create!(invoice_id: invoice.id, result: 'success')
end

def merchant_revenue_40
  @merchant_revenue_40 = create(:merchant, name: 'Merchant 4')
  customer = create(:customer)
  item_1 = @merchant_revenue_40.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 10)
  invoice_1 = Invoice.create!(customer_id: customer.id, merchant_id: @merchant_revenue_40.id, status: 'shipped')
  InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 1, unit_price: 40)
  Transaction.create!(invoice_id: invoice_1.id, result: 'success')
end

def merchant_revenue_50
  @merchant_revenue_50 = create(:merchant, name: 'Merchant 5')
  customer = create(:customer)
  item_1 = @merchant_revenue_50.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 10)
  invoice_1 = Invoice.create!(customer_id: customer.id, merchant_id: @merchant_revenue_50.id, status: 'shipped')
  InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 1, unit_price: 50)
  Transaction.create!(invoice_id: invoice_1.id, result: 'success')
end

def merchant_revenue_1
  @merchant_revenue_1 = create(:merchant, name: 'Merchant 6')
  customer = create(:customer)
  item = @merchant_revenue_1.items.create!(name: 'Item', description: 'foo bar baz quux', unit_price: 10)
  invoice = Invoice.create!(customer_id: customer.id, merchant_id: @merchant_revenue_1.id, status: 'shipped')
  InvoiceItem.create!(invoice_id: invoice.id, item_id: item.id, quantity: 1, unit_price: 1)
  Transaction.create!(invoice_id: invoice.id, result: 'success')
end

def merchant_revenue_6
  @merchant_revenue_6 = create(:merchant, name: 'Merchant 7')
  customer = create(:customer)
  item_1 = @merchant_revenue_6.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 10)
  item_2 = @merchant_revenue_6.items.create!(name: 'Item 2', description: 'foo bar baz quux', unit_price: 20)
  invoice_1 = Invoice.create!(customer_id: customer.id, merchant_id: @merchant_revenue_6.id, status: 'shipped')
  invoice_2 = Invoice.create!(customer_id: customer.id, merchant_id: @merchant_revenue_6.id, status: 'shipped')
  InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 1, unit_price: 3)
  InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_2.id, quantity: 1, unit_price: 3)
  Transaction.create!(invoice_id: invoice_1.id, result: 'success')
  Transaction.create!(invoice_id: invoice_2.id, result: 'success')
end
