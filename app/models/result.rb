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
class Result < ApplicationRecord
  # Properties
  self.table_name = 'results'
  self.primary_key = 'id'

  # Relationships
  belongs_to :compettition
  belongs_to :athlete

  # Validations
  validates_presence_of :value, :compettition_id, :athlete_id
end
