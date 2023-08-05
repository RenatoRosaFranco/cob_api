# frozen_string_literal: true

class SubscriptionValidator
  def initialize(result)
    @result = result
    @competition = result.competition
    @athlete = result.athlete
  end

  def validate
    if @competition && @athlete && !@competition.subscribed?(@athlete)
      @result.errors.add :subscription, "O Atleta não foi inscrito nesta competição"
    end
  end
end
