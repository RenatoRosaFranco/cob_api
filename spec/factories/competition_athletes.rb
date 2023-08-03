# == Schema Information
#
# Table name: competition_athletes
#
#  id             :integer          not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  athlete_id     :integer          not null
#  competition_id :integer          not null
#
# Indexes
#
#  index_competition_athletes_on_athlete_id      (athlete_id)
#  index_competition_athletes_on_competition_id  (competition_id)
#
# Foreign Keys
#
#  athlete_id      (athlete_id => athletes.id)
#  competition_id  (competition_id => competitions.id)
#
FactoryBot.define do
  factory :competition_athlete do
    competition
    athlete
  end
end
