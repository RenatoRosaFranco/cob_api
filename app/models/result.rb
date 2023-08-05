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
  self.table_name  = 'results'
  self.primary_key = 'id'

  # Relationships
  belongs_to :competition
  belongs_to :athlete

  # Validations
  validates_presence_of :value, :competition_id, :athlete_id

  # Custom Validators
  validate do |result|
    CompetitionStatusValidator.new(result).validate
    SubscriptionValidator.new(result).validate
    MaxAttemptsValidator.new(result).validate
  end
end
