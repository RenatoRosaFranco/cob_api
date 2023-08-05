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
require 'rails_helper'

RSpec.describe CompetitionAthlete, type: :model do
  subject { FactoryBot.create(:competition_athlete, { competition: competition, athlete: athlete }) }

  let(:athlete) { FactoryBot.create(:athlete, { name: 'Hanzo Kimura' }) }
  let(:competition) { FactoryBot.create(:competition) }

  context 'valid object' do
    it { should be_valid(subject) }
  end

  context '.validations' do
    it { should validate_presence_of(:athlete) }
    it { should validate_presence_of(:competition) }
  end

  context '.relationships' do
    it { should belong_to(:athlete) }
    it { should belong_to(:competition) }
  end
end
