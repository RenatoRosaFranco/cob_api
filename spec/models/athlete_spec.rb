# == Schema Information
#
# Table name: athletes
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Athlete, type: :model do
  subject { FactoryBot.build(:athlete, { name: 'Hanzo Kimura' }) }

  context 'valid object' do
    it { should be_valid(subject) }
  end

  context '.validations' do
    it { should validate_presence_of(:name) }
  end

  context '.relationships' do
    it { should have_many(:competition_athletes) }
    it { should have_many(:competitions).through(:competition_athletes) }
    it { should have_many(:results) }
  end
end
