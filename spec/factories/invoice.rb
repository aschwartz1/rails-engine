FactoryBot.define do
  factory :invoice do
    status { 'shipped' or 'returned' or 'packaged' }

    trait :shipped do
      status { :shipped }
    end

    trait :returned do
      status { :returned }
    end

    trait :packaged do
      status { :packaged }
    end
    customer
    merchant
  end
end
