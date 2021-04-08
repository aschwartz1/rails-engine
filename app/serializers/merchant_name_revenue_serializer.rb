class MerchantNameRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attribute :name
  attribute :revenue, &:total_revenue
end
