# frozen_string_literal: true

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
class Competition < ApplicationRecord
  # Properties
  self.table_name = 'competitions'
  self.primary_key = 'id'

  # Enum
  enum status: %i[open closed]

  # Relationships
  has_many :competition_athletes
  has_many :athletes, through: :competition_athletes
  has_many :results

  # Validations
  validates_presence_of :name, :unit
  validates_uniqueness_of :name
end
