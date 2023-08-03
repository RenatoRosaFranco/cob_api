# == Schema Information
#
# Table name: athletes
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Athlete < ApplicationRecord
  include AthleteInterface

  # Properties
  self.table_name  = 'athletes'
  self.primary_key = 'id'

  # Relationships
  has_many :competition_athletes
  has_many :competitions, through: :competition_athletes
  has_many :results

  # Validations
  validates_presence_of :name
end
