# == Schema Information
#
# Table name: results
#
#  id             :integer          not null, primary key
#  value          :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  athlete_id     :integer          not null
#  competition_id :integer          not null
#
# Indexes
#
#  index_results_on_athlete_id      (athlete_id)
#  index_results_on_competition_id  (competition_id)
#
# Foreign Keys
#
#  athlete_id      (athlete_id => athletes.id)
#  competition_id  (competition_id => competitions.id)
#
FactoryBot.define do
  factory :result do
    value { rand(8..12).to_f }

    trait :dart_result do
      value { rand(60..80).to_f }
    end

    athlete
    competition

    trait :in_competition do
      after(:create) do |result, evaluator|
        create(:competition_athlete, {
          athlete: result.athlete,
          competition: result.competition
        })
      end 
    end
  end
end
