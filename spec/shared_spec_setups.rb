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
