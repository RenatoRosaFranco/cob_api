# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::CompetitionsController, type: :controller do
  let(:response_body) { JSON.parse(response.body) }
  let(:not_found_message) { { 'error' => 'Competition not found' } }

  describe 'GET #index' do
    let(:competitions) { Competition.order(created_at: :desc).as_json }

    before do
      FactoryBot.create_list(:athlete, 3)
    end

    it 'returns a sucessfull response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns competitions', :aggregate_failures do
      get :index
      expect(response).to have_http_status(:success)
      expect(response_body).to eq(competitions)
    end
  end

  describe 'GET #show' do
    let(:competition) { FactoryBot.create(:competition) }

    it 'returns a sucessfull response', :aggregate_failures do
      get :show, params: { id: competition.id }
      expect(response).to be_successful
      expect(assigns(:competition)).to eq(competition)
    end

    it 'return a not found for invalid competition id', :aggregate_failures do
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq(not_found_message)
    end
  end

  describe 'POST #create' do
    let(:competition) { FactoryBot.attributes_for(:competition, name: '100m Rasos') }

    it 'creates a new competition', :aggregate_failures do
      expect {
        post :create, params: { competition: competition }
      }.to change(Competition, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(response_body['competition']['id']).to eq(Competition.last.id)
      expect(response_body['competition']['name']).to eq('100m Rasos')
    end

    it 'returns a unprocessable entity for invalid params', :aggregate_failures do
      expect {
        post :create, params: { competition: { name: '' } }
      }.not_to change(Competition, :count)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body['errors']['name']).to eq(['can\'t be blank'])
    end
  end

  describe 'PATCH #update' do
    let(:name) { 'Arremeso de Peso' }
    let(:competition) { FactoryBot.create(:competition) }

    it 'updates the competition', :aggregate_failures do
      patch :update, params: { id: competition.id, competition: { name: name } }
      competition.reload

      expect(response).to have_http_status(:ok)
      expect(response_body['competition']['id']).to eq(competition.id)
      expect(response_body['competition']['name']).to eq(name)
    end

    it 'return unprocessable_entity for invalid competition params', :aggregate_failures do
      patch :update, params: { id: competition.id, competition: { name: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({ 'errors' => { 'name' => ['can\'t be blank'] } })
    end

    it 'return not found for invalid competition', :aggregate_failures do
      patch :update, params: { id: 999, competition: { name: '' } }
      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq(not_found_message)
    end
  end

  describe 'DELETE #destroy' do
    let!(:competition) { FactoryBot.create(:competition) }

    it 'deletes the competition', :aggregate_failures do
      expect {
        delete :destroy, params: { id: competition.id }
      }.to change(Competition, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'return not found for invalid competition id' do
      delete :destroy, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq(not_found_message)
    end
  end
end
