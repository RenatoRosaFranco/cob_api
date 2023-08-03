# == Schema Information
#
# Table name: competitions
#
#  id           :integer          not null, primary key
#  max_attempts :integer          default(1)
#  name         :string
#  status       :integer          default("open")
#  unit         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :competition do
    name { '100m Classificatória 1' }
    status { 'open' }
    max_attempts { 1 }
    unit { 's' }

    trait :closed do
      status { 'closed' }
    end

    trait :dart_competition do
      name { 'Dardo semifinal' }
      max_attempts { 3 }
      unit { 'm' }
    end
  end
end
