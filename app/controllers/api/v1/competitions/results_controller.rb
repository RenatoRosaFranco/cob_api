# frozen_string_literal: true

module API
  module V1
    module Competitions
      class ResultsController < CompetitionsController
        rescue_from ActiveRecord::RecordNotFound, with: :not_found

        before_action :set_competition
        before_action :set_result, only: %i[show update destroy]

        def index
          results = @competition.results.order(created_at: :desc)
          render json: results
        end

        def create
          result = Result.new(result_params)

          if result.save
            render json: {
              result: result
            }, status: :created
          else
            render json: {
              errors: result.errors
            }, status: :unprocessable_entity
          end
        end

        def show
          render json: @result
        end

        def update
          if @result.update(result_params)
            render json: {
              result: @result
            }, status: :ok
          else
            render json: {
              errors: @result.errors
            }, status: :unprocessable_entity
          end
        end

        def destroy
          @result.destroy
          head :no_content
        end

        private

        def set_competition
          @competition = Competition.find(params[:competition_id])
        end

        def set_result
          @result = Result.find(params[:id])
        end

        def result_params
          params.require(:result).permit(:value, :competition_id, :athlete_id)
        end

        def not_found
          render json: {
            'error' => 'Result not found'
          }, status: :not_found
        end
      end
    end
  end
end
