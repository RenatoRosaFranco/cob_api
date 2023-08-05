# frozen_string_literal: true

module CompetitionInterface
  extend ActiveSupport::Concern

  included do
    def status?
      currently_open? ? 'aberta' : 'encerrada'
    end

    def ranking_status?
      currently_open? ? 'parcial' : 'final'
    end

    def subscribed?(athlete)
      athletes.where(id: athlete.id).present?
    end

    def exceeded_attempts?(athlete)
      attempts = athlete.results.where(competition_id: id).count
      attempts >= max_attempts
    end

    def ranking
      results.joins(:competition, :athlete)
             .select( 'results.id,
                competitions.name as competicao,
                athletes.name as atleta,
                MAX(value) as value,
                competitions.unit as unidade'
              ).group(:athlete_id).order(value: :"#{ranking_rule}")
    end
  end
end
