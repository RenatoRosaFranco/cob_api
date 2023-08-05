# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::Competitions::CompetitionAthletesController, type: :controller do
  let(:response_body) { JSON.parse(response.body) }
  let(:not_found_message) { { 'error' => 'CompetitionAthlete not found' } }

  let(:competition) { FactoryBot.create(:competition, name: '100m Rasos Classificatória') }

  describe 'GET #index' do
    let(:competition_athletes) { competition.competition_athletes.order(created_at: :desc).as_json }

    before do
      FactoryBot.create_list(:competition_athlete, 3, competition: competition)
    end

    it 'returns a sucessfull response' do
      get :index, params: { competition_id: competition.id }
      expect(response).to be_successful
    end

    it 'assigns competition_athletes', :aggregate_failures do
      get :index, params: { competition_id: competition.id }
      expect(response).to have_http_status(:success)
      expect(response_body).to eq(competition_athletes)
    end
  end

  describe 'GET #show' do
    let(:competition_athlete) { FactoryBot.create(:competition_athlete, competition: competition) }

    it 'returns a sucessfull response', :aggregate_failures do
      get :show, params: { competition_id: competition.id, id: competition_athlete.id }
      expect(assigns(:competition_athlete)).to eq(competition_athlete)
    end

    it 'return a not found for a invalid competition_athlete id', :aggregate_failures do
      get :show, params: { id: 999, competition_id: competition.id }
      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq(not_found_message)
    end
  end

  describe 'POST #create' do
    let(:athlete) { FactoryBot.create(:athlete, { name: 'Patricia Oro' }) }
    let(:competition_athlete) do
      FactoryBot.attributes_for(:competition_athlete, { athlete_id: athlete.id, competition_id: competition.id })
    end

    it 'create a new competition_athlete', :aggregate_failures do
      expect { post :create, params: {
        competition_id: competition.id,
        competition_athlete: competition_athlete
      }}.to change(CompetitionAthlete, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(response_body['competition_athlete']['id']).to eq(Competition.last.id)
      expect(response_body['competition_athlete']['competition_id']).to eq(competition.id)
    end

    it 'returns unprocessable entity for invalid params', :aggregate_failures do
      expect { post :create, params: {
        competition_id: competition.id,
        competition_athlete: { competition_id: nil, athlete_id: athlete.id }
      }}.not_to change(CompetitionAthlete, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({ 'errors' => {
        'competition' => ['must exist', 'can\'t be blank']
      } })
    end
  end

  describe 'PATCH #update' do
    let(:competition_athlete) { FactoryBot.create(:competition_athlete, competition: competition) }
    let(:competition2) { FactoryBot.create(:competition, name: '400m Rasos Classificatória') }

    it 'updates the competition', :aggregate_failures do
      patch :update, params: {
        id: competition_athlete.id, competition_id: competition.id,
        competition_athlete: { competition_id: competition2.id }
      }
      expect(response).to have_http_status(:ok)
      expect(response_body['competition_athlete']['id']).to eq(competition_athlete.id)
      expect(response_body['competition_athlete']['competition_id']).to eq(competition2.id)
    end

    it 'return unprocessable_entity for invalid competition_athlete', :aggregate_failures do
      patch :update, params: {
        id: competition_athlete.id,
        competition_id: competition.id,
        competition_athlete: { competition_id: nil }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({ 'errors' => { 
        'competition' => ['must exist', 'can\'t be blank'] 
      } })
    end

    it 'return not found for invalid competition_athlete', :aggregate_failures do
      patch :update, params: { id: 999, competition_id: competition.id, competition_athlete: { competition_id: competition2.id } }
      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq(not_found_message)
    end
  end

  describe 'DELETE #destroy' do
    let!(:competition_athlete) { FactoryBot.create(:competition_athlete, competition: competition) }

    it 'delete the competition_athlete', :aggregate_failures do
      expect {
        delete :destroy, params: { id: competition_athlete.id, competition_id: competition.id }
      }.to change(CompetitionAthlete, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'return not found for invalid competition id', :aggregate_failures do
      delete :destroy, params: { id: 999, competition_id: competition.id }
      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq(not_found_message)
    end
  end
end
