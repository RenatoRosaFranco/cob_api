# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::Competitions::ResultsController, type: :controller do
  let(:response_body) { JSON.parse(response.body) }
  let(:not_found_message) { { 'error' => 'Result not found' } }

  let(:competition) { FactoryBot.create(:competition, name: '500m Rasos') }

  describe 'GET #index' do
    let(:results) { competition.results.order(created_at: :desc).as_json }

    before do
      FactoryBot.create_list(:result, 5, :in_competition)
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
    let(:result) do
      FactoryBot.create(:result, :in_competition, competition: competition)
    end

    it 'returns a sucessfull response', :aggregate_failures do
      get :show, params: { id: result.id, competition_id: result.competition.id }
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
    let(:competition) { FactoryBot.create(:competition, { name: '100m Rasos Final', status: 'open' }) }
    let(:result) do
      FactoryBot.attributes_for(:result,  { athlete_id: athlete.id, competition_id: competition.id, value: 10.0 })
    end

    before do
      FactoryBot.create(:competition_athlete, {
        competition_id: competition.id, athlete_id: athlete.id
      })
    end

    context 'when competition is open' do
      it 'creates a new result' do
        expect {
          post :create, params: { 
          competition_id: competition.id, result: result
        }}.to change(Result, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(response_body['result']['id']).to eq(Result.last.id)
        expect(response_body['result']['value']).to eq(10.0)
      end

      context 'when athlete is not subscribed' do

      end

      context 'when athlete exceeds max attempts' do
        let(:error_message) { 'O Atleta excedeu o nº máximo de tentativas' }

        before do
          FactoryBot.create(:result,  { 
            athlete_id: athlete.id, 
            competition_id: competition.id, 
            value: 10.0 
          })
        end

        it 'not create a new result' do
          expect {
            post :create, params: {
            competition_id: competition.id, result: result
          }}.not_to change(Result, :count)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response_body['errors']['max_attempts']).to eq([error_message])
        end
      end
    end

    context 'when competition is closed' do
      let(:competition) { FactoryBot.create(:competition, { name: '400m', status: 'closed' }) }
      let(:error_message) { 'Esta competição já foi encerrada' }

      it 'not create a new result' do
        expect {
          post :create, params: { 
          competition_id: competition.id, result: result
        }}.not_to change(Result, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body['errors']['status']).to eq([error_message])
      end
    end

    it 'returns unprocessable entity for invalid params', :aggregate_failures do
      expect { 
          post :create, params: { 
          competition_id: competition.id, result: { 
          competition_id: competition.id, athlete_id: athlete.id, value: nil 
        }
      }}.not_to change(Result, :count)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body['errors']['value']).to eq(['can\'t be blank'])
    end
  end

  describe 'PATCH #update' do
    let(:value) { rand(7..10).to_f }
    let(:athlete) { result.athlete }
    let!(:result) { FactoryBot.create(:result, :in_competition) }
    
    let(:result_params) do
      FactoryBot.attributes_for(:result, {
        competition_id: competition.id,
        athlete_id: athlete.id,
        value: value
      })
    end

    before do
      FactoryBot.create(:competition_athlete, {
        competition_id: competition.id, athlete_id: athlete.id
      })
    end

    context 'when competition is open' do
      it 'updates the result', :aggregate_failures do
        patch :update, params: {
          id: result.id, 
          competition_id: competition.id, 
          result: result_params
        }

        expect(response).to have_http_status(:ok)
        expect(response_body['result']['id']).to eq(result.id)
        expect(response_body['result']['value']).to eq(result_params[:value])
      end

      context 'when athlete exceeds max attempts' do
        let(:error_message) { 'O Atleta excedeu o nº máximo de tentativas' }

        let(:athlete2) { FactoryBot.create(:athlete, { name: 'Pia Skrzyszowska' }) }
        let(:result_params) do
          FactoryBot.attributes_for(:result, {
            competition_id: competition.id,
            athlete_id: athlete.id,
            value: value
          })
        end

        before do
          FactoryBot.create(:competition_athlete, {
            competition_id: competition.id, athlete_id: athlete2.id
          })

          FactoryBot.create(:result, {
            competition_id: competition.id,
            athlete_id: athlete2.id,
          })

          FactoryBot.create(:result, {
            competition_id: competition.id,
            athlete_id: athlete.id,
          })
        end

        it 'not update a result' do
          expect {
            post :update, params: {
            id: athlete2.results.last.id,
            competition_id: competition.id,
            result: result_params
          }}.not_to change(Result, :count)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response_body['errors']['max_attempts']).to eq([error_message])
        end
      end
    end

    context 'when competition is closed' do
      let(:error_message) { ['Esta competição já foi encerrada'] }

      before { competition.currently_closed! }

      it 'could not update the given result', :aggregate_failures do
        patch :update, params: {
          id: result.id, 
          competition_id: competition.id, 
          result: result_params
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body['errors']['status']).to eq(error_message)
      end
    end

    it 'return unprocessable_entity for invalid result params', :aggregate_failures do
      patch :update, params: {
        id: result.id, competition_id: competition.id,
        result: { competition_id: competition.id, athlete_id: athlete.id, value: nil }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({ 'errors' => { 'value' => ['can\'t be blank'] } })
    end

    it 'return not found for invalid result', :aggregate_failures do
      patch :update, params: {
        id: 999, competition_id: competition.id, result: result_params
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