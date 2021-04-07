class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :merchant_id

  attribute :unit_price do |item|
    if item.id.nil?
      nil
    else
      item.unit_price.to_f
    end
  end
end
