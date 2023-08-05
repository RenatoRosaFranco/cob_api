# frozen_string_literal: true

module API
  module V1
    module Competitions
      class CompetitionAthletesController < CompetitionsController
        rescue_from ActiveRecord::RecordNotFound, with: :not_found

        before_action :set_competition
        before_action :set_competition_athlete, only: %i[show update destroy]

        def index
          competition_athletes = @competition.competition_athletes.order(created_at: :desc)
          render json: competition_athletes
        end

        def create
          competition_athlete = CompetitionAthlete.new(competition_athlete_params)

          if competition_athlete.save
            render json: {
              competition_athlete: competition_athlete
            }, status: :created
          else
            render json: {
              errors: competition_athlete.errors
            }, status: :unprocessable_entity
          end
        end

        def show
          render json: @competition_athlete
        end

        def update
          if @competition_athlete.update(competition_athlete_params)
            render json: {
              competition_athlete: @competition_athlete
            }, status: :ok
          else
            render json: {
              errors: @competition_athlete.errors
            }, status: :unprocessable_entity
          end
        end

        def destroy
          @competition_athlete.destroy
          head :no_content
        end

        private

        def set_competition
          @competition = Competition.find(params[:competition_id])
        end

        def set_competition_athlete
          @competition_athlete = CompetitionAthlete.find(params[:id])
        end

        def competition_athlete_params
          params.require(:competition_athlete).permit(:athlete_id, :competition_id)
        end

        def not_found
          render json: {
            'error' => 'CompetitionAthlete not found'
          }, status: :not_found
        end
      end
    end
  end
end
