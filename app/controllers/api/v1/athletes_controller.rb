# frozen_string_literal: true

module API
  module V1
    class AthletesController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      before_action :set_athlete, only: %i[show update destroy]

      def index
        athletes = Athlete.order(created_at: :desc)
        render json: athletes
      end

      def create
        athlete = Athlete.new(athlete_params)

        if athlete.save
          render json: {
            athlete: athlete
          }, status: :created
        else
          render json: {
            errors: athlete.errors
          }, status: :unprocessable_entity
        end
      end

      def show
        render json: @athlete
      end

      def update
        if @athlete.update(athlete_params)
          render json: {
            athlete: @athlete
          }, status: :ok
        else
          render json: {
            errors: @athlete.errors
          }, status: :unprocessable_entity
        end
      end

      def destroy
        @athlete.destroy
        head :no_content
      end

      private

      def set_athlete
        @athlete = Athlete.find(params[:id])
      end

      def athlete_params
        params.require(:athlete).permit(:name)
      end

      def not_found
        render json: {
          error: 'Athlete not found'
        }, status: :not_found
      end
    end
  end
end
