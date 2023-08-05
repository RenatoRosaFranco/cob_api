# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AthleteInterface, type: :interface do
  subject { athlete }

  let(:athlete) { FactoryBot.create(:athlete, { name: 'Renato Franco'}) }
  let(:competition) { FactoryBot.create(:competition, :dart_competition) }
  let(:competition_athlete) do
    FactoryBot.create(:competition_athlete, {
      athlete: athlete,
      competition: competition
    })
  end

  context '.athlete_results' do
    before do
      FactoryBot.create_list(:result, 3, {
        athlete: athlete, competition: competition
      })
    end

    it { expect(athlete.athlete_results(competition).count).to eq(3) }
  end

  context '.hightlight_result', :aggregate_failures do
    let(:athlete_best_score) do
      competition.results.select('MAX(value) as value, id, athlete_id')
        .where(athlete: athlete).order(value: :"#{competition.ranking_rule}").first
    end

    before do
      FactoryBot.create_list(:result, 3, { athlete: athlete, competition: competition })
    end

    it { expect(athlete.highlight_result(competition).count).to eq(1) }
    it { expect(athlete.highlight_result(competition).first.value).to eq(athlete_best_score.value) }
  end
end
