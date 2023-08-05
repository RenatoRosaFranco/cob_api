# frozen_string_literal: true

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
require 'rails_helper'

RSpec.describe Competition, type: :model do
  subject { FactoryBot.build(:competition) }

  context 'valid object' do
    it { should be_valid(subject) }
  end

  context '.validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:unit) }
    it { should validate_presence_of(:ranking_rule) }
    it { should validate_presence_of(:max_attempts) }
  end

  context '.relationships' do
    it { should have_many(:competition_athletes) }
    it { should have_many(:athletes).through(:competition_athletes) }
    it { should have_many(:results) }
  end
end
