# frozen_string_literal: true

class MaxAttemptsValidator
  def initialize(result)
    @result = result
    @competition = result.competition
    @athlete = result.athlete
  end

  def validate
    if @competition && @athlete && @competition.exceeded_attempts?(@athlete)
      @result.errors.add :max_attempts, "O Atleta excedeu o nº máximo de tentativas"
    end
  end
end
