class MerchantRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attribute :revenue, &:total_revenue
end
