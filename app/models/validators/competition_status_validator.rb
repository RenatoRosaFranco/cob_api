# frozen_string_literal: true

class CompetitionStatusValidator
  def initialize(result)
    @result = result
    @competition = result.competition
  end

  def validate
    if @competition && @competition.currently_closed?
      @result.errors.add :status, 'Esta competição já foi encerrada'
    end
  end
end