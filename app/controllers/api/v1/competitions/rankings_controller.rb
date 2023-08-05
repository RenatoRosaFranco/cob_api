# frozen_string_literal: true

module API
  module V1
    module Competitions
      class RankingsController < CompetitionsController
        rescue_from  ActiveRecord::RecordNotFound, with: :not_found
        before_action :set_competition

        def index
          scores = @competition.ranking
          render json: {
            ranking_type: @competition.ranking_status?,
            ranking: scores
          }, status: :ok
        end

        private

        def set_competition
          @competition = Competition.find(params[:competition_id])
        end

        def not_found
          render json: {
            error: 'Competition not found'
          }, status: :not_found
        end
      end
    end
  end
end
