# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::AthletesController, type: :controller do
  let(:response_body) { JSON.parse(response.body) }
  let(:not_found_message) { { 'error' => 'Athlete not found' } }

  describe 'GET #index' do
    let(:athletes) { Athlete.order(created_at: :desc).as_json }

    before do
      FactoryBot.create_list(:athlete, 3)
    end

    it 'returns a sucessfull response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns athletes', :aggregate_failures do
      get :index
      expect(response).to have_http_status(:success)
      expect(response_body).to eq(athletes)
    end
  end

  describe 'GET #show' do
    let(:athlete) { FactoryBot.create(:athlete) }

    it 'returns a sucessfull response', :aggregate_failures do
      get :show, params: { id: athlete.id }
      expect(response).to be_successful
      expect(assigns(:athlete)).to eq(athlete)
    end

    it 'return a not found for invalid athlete id', :aggregate_failures do
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq(not_found_message)
    end
  end

  describe 'POST #create' do
    let(:athlete) { FactoryBot.attributes_for(:athlete, name: 'Hanzo Kimura') }

    it 'creates a new athlete', :aggregate_failures do
      expect { post :create, params: { athlete: athlete } }.to change(Athlete, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(response_body['athlete']['id']).to eq(Athlete.last.id)
      expect(response_body['athlete']['name']).to eq('Hanzo Kimura')
    end

    it 'returns unprocessable entity for invalid params', :aggregate_failures do
      expect { post :create, params: { athlete: { name: '' } }}.not_to change(Athlete, :count)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({ 'errors' => { 'name' => ['can\'t be blank'] } })
    end
  end

  describe 'PATCH #update' do
    let(:name) { 'Sergey Karjakin' }
    let(:athlete) { FactoryBot.create(:athlete) }

    it 'updates the athlete', :aggregate_failures do
      patch :update, params: { id: athlete.id, athlete: { name: name } }
      athlete.reload

      expect(response).to have_http_status(:ok)
      expect(response_body['athlete']['id']).to eq(athlete.id)
      expect(response_body['athlete']['name']).to eq(name)
    end

    it 'return unprocessable_entity for invalid athlete params', :aggregate_failures do
      patch :update, params: { id: athlete.id, athlete: { name: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({ 'errors' => { 'name' => ['can\'t be blank'] } })
    end

    it 'returns not found for invalid athlete id', :aggregate_failures do
      patch :update, params: { id: 999, athlete: { name: 'Miyamoto Musashi' } }
      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq(not_found_message)
    end
  end

  describe 'DELETE #destroy' do
    let!(:athlete) { FactoryBot.create(:athlete) }

    it 'deletes the athlete', :aggregate_failures do
      expect {
        delete :destroy, params: { id: athlete.id }
      }.to change(Athlete, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'return not found for invalid athlete id', :aggregate_failures do
      delete :destroy, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq(not_found_message)
    end
  end
end
