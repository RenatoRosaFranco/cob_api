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
require 'rails_helper'

RSpec.describe Result, type: :model do
  subject do 
    FactoryBot.build(:result, { competition: competition, athlete: athlete })
  end

  let(:athlete) { FactoryBot.create(:athlete, name: 'Piotr Lisek') }
  let(:competition) { FactoryBot.create(:competition) }

  before do
    FactoryBot.create(:competition_athlete, {
      competition_id: competition.id, athlete_id: athlete.id
    })
  end

  context 'valid object' do
    it { should be_valid(subject) }
  end

  context '.validations' do
    it { should validate_presence_of(:athlete_id) }
    it { should validate_presence_of(:competition_id) }
    it { should validate_presence_of(:value) }
  end

  context '.relationships' do
    it { should belong_to(:competition) }
    it { should belong_to(:athlete) }
  end
end
