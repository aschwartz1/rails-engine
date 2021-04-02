FactoryBot.define do
  factory :invoice do
    status { 'shipped' or 'returned' or 'packaged' }

    customer
    merchant
  end
end
