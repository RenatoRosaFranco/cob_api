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
class CompetitionAthlete < ApplicationRecord
  # Properties
  self.table_name = 'competition_athletes'
  self.primary_key = 'id'

  # Relationships
  belongs_to :competition
  belongs_to :athlete

  # Validations
  validates_presence_of :competition_id, :athlete_id
  validates_uniqueness_of :athlete_id, scope: [:competition_id]
end
