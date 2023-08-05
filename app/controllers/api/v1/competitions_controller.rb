# frozen_string_literal: true

module API
  module V1
    class CompetitionsController < ApplicationController
      rescue_from  ActiveRecord::RecordNotFound, with: :not_found
      before_action :set_competition, only: %i[show update destroy]

      def index
        competitions = Competition.order(created_at: :desc)
        render json: competitions
      end

      def create
        competition = Competition.new(competition_params)

        if competition.save
          render json: {
            competition: competition
          },status: :created
        else
          render json: {
            errors: competition.errors
          }, status: :unprocessable_entity
        end
      end

      def show
        render json: @competition
      end

      def update
        if @competition.update(competition_params)
          render json: {
            competition: @competition
          }, status: :ok
        else
          render json: {
            errors: @competition.errors
          }, status: :unprocessable_entity
        end
      end

      def destroy
        @competition.destroy
        head :no_content
      end

      private

      def set_competition
        @competition = Competition.find(params[:id])
      end

      def competition_params
        params.require(:competition).permit(:name, :status, :unit, :ranking_rule, :max_attempts)
      end

      def not_found
        render json: {
          error: 'Competition not found'
        }, status: :not_found
      end
    end
  end
end
