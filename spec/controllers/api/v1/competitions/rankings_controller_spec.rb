# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::Competitions::RankingsController, type: :controller do
  let(:response_body) { JSON.parse(response.body) }
  let(:not_found_message) { { 'error' => 'Competition not found' } }

  let(:competition) { FactoryBot.create(:competition, status: 'open') }

  describe 'GET #index' do
    let(:ranking) { competition.ranking.as_json }

    before do
      FactoryBot.create_list(:result, 12, :in_competition, { 
        competition:competition
      })
    end

    context 'when competition is open' do
      it 'returns a sucessfull response' do
        get :index, params: { competition_id: competition.id }
        expect(response).to be_successful
      end

      it 'assigns parcial ranking scores', :aggregate_failures do
        get :index, params: { competition_id: competition.id }
        expect(response).to have_http_status(:success)
        expect(response_body['ranking_type']).to eq('parcial')
        expect(response_body['ranking']).to eq(ranking)
      end
    end

    context 'when competition is closed' do
      let(:competition) { FactoryBot.create(:competition) }
    
      before do
        FactoryBot.create_list(:result, 12, :in_competition, {
          competition_id: competition.id
        })

        competition.currently_closed!
      end

      it 'returns a sucessfull response' do
        get :index, params: { competition_id: competition.id }
        expect(response).to be_successful
      end

      it 'assigns final ranking scores', :aggregate_failures do
        get :index, params: { competition_id: competition.id }
        expect(response).to have_http_status(:success)
        expect(response_body['ranking_type']).to eq('final')
        expect(response_body['ranking']).to eq(ranking)
      end
    end

    context 'without a competition' do
      it 'return not found for invalid competition id', :aggregate_failures do
        get :index, params: { competition_id: 999 }
        expect(response).to have_http_status(:not_found)
        expect(response_body).to eq(not_found_message)
      end
    end
  end
end