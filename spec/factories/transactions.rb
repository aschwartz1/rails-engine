FactoryBot.define do
  factory :transaction do
    credit_card_number { Faker::Business.credit_card_number }
    credit_card_expiration_date { Faker::Business.credit_card_expiry_date }

    result { 'failed' or 'refunded' or 'success' }

    trait :failed do
      result { 'failed' }
    end

    trait :refunded do
      result { 'refunded' }
    end

    trait :success do
      result { 'success' }
    end

    invoice
  end
end
