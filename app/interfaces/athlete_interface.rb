# frozen_string_literal: true

module AthleteInterface
  extend ActiveSupport::Concern

  included do
    def athlete_results(competition)
      results.where(competition: competition)
    end

    def highlight_result(competition)
      results.select('MAX(value) as value, id, athlete_id, competition_id')
             .where(competition: competition)
             .order(value: :"#{competition.ranking_rule}")
             .limit(1)
    end
  end
end
