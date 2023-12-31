# == Schema Information
#
# Table name: competitions
#
#  id           :integer          not null, primary key
#  max_attempts :integer          default(1)
#  name         :string
#  ranking_rule :string           default("asc")
#  status       :integer          default("open")
#  unit         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :competition do
    name { FFaker::SportUS.name }
    status { 'open' }
    ranking_rule { 'asc' }
    max_attempts { 1 }
    unit { 's' }
    
    trait :running_competition do
      name { '100m Classificatória 1' }
      ranking_rule { 'asc' }
      max_attempts { 1 }
      unit { 's' }
    end

    trait :dart_competition do
      name { 'Dardo semifinal' }
      ranking_rule { 'desc' }
      max_attempts { 3 }
      unit { 'm' }
    end

    trait :closed do
      status { 'closed' }
    end
  end
end
