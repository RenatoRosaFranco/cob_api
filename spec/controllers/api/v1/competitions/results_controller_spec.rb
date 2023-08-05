# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::Competitions::ResultsController, type: :controller do
  let(:response_body) { JSON.parse(response.body) }
  let(:not_found_message) { { 'error' => 'Result not found' } }

  let(:competition) { FactoryBot.create(:competition) }

  describe 'GET #index' do
    let(:results) { competition.results.order(created_at: :desc).as_json }

    before do
      FactoryBot.create_list(:result, 3, :in_competition, competition: competition)
    end

    it 'returns a sucessfull response' do
      get :index, params: { competition_id: competition.id }
      expect(response).to be_successful
    end

    it 'assigns results', :aggregate_failures do
      get :index, params: { competition_id: competition.id }
      expect(response).to have_http_status(:success)
      expect(response_body).to eq(results)
    end
  end

  describe 'GET #show' do
    let(:result) { FactoryBot.create(:result, :in_competition) }

    it 'returns a sucessfull response', :aggregate_failures do
      get :show, params: { id: result.id, competition_id: competition.id }
      expect(assigns(:result)).to eq(result)
    end

    it 'return a not found for invalid result id', :aggregate_failures do
      get :show, params: { id: 999, competition_id: competition.id }
      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq(not_found_message)
    end
  end

  describe 'POST #create' do
    let(:athlete) { FactoryBot.create(:athlete,  { name: 'Anastacja Kús' }) }
    let(:competition) { FactoryBot.create(:competition, { name: '100m Rasos Final' }) }
    let(:result) do
      FactoryBot.attributes_for(:result,  { athlete_id: athlete.id, competition_id: competition.id, value: 10.0 })
    end

    it 'creates a new result' do
      expect {
        post :create, params: { 
        competition_id: competition.id, result: result
      }}.to change(Result, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(response_body['result']['id']).to eq(Result.last.id)
      expect(response_body['result']['value']).to eq(10.0)
    end

    it 'returns unprocessable entity for invalid params', :aggregate_failures do
      expect { 
          post :create, params: { 
          competition_id: competition.id, result: { 
          competition_id: competition.id, athlete_id: nil, value: rand(10.0) 
        }
      }}.not_to change(Result, :count)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body['errors']['athlete_id']).to eq(['can\'t be blank'])
    end
  end

  describe 'PATCH #update' do
    let(:value) { rand(7..10).to_f }
    let(:athlete) { result.athlete }
    let!(:result) { FactoryBot.create(:result, :in_competition) }
    
    let(:new_result) do
      FactoryBot.attributes_for(:result, {
        competition_id: competition.id,
        athlete_id: athlete.id,
        value: value
      })
    end

    it 'updates the result', :aggregate_failures do
      patch :update, params: {
        id: result.id, 
        competition_id: competition.id, 
        result: new_result
      }

      expect(response).to have_http_status(:ok)
      expect(response_body['result']['id']).to eq(result.id)
      expect(response_body['result']['value']).to eq(new_result[:value])
    end

    it 'return unprocessable_entity for invalid competition params', :aggregate_failures do
      patch :update, params: {
        id: result.id, competition_id: competition.id,
        result: { competition_id: competition.id, athlete_id: athlete.id, value: nil }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({ 'errors' => { 'value' => ['can\'t be blank'] } })
    end

    it 'return not found for invalid result', :aggregate_failures do
      patch :update, params: {
        id: 999, competition_id: competition.id, result: new_result
      }

      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq(not_found_message)
    end
  end

  describe 'DELETE destroy' do
    let!(:result) { FactoryBot.create(:result, :in_competition, competition_id: competition.id) }

    it 'delete the result', :aggregate_failures do
      expect {
        delete :destroy, params: { id: result.id, competition_id: competition.id }
      }.to change(Result, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'return not found for invalid result id' do
      delete :destroy, params: { id: 999, competition_id: competition.id }
      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq(not_found_message)
    end
  end
end