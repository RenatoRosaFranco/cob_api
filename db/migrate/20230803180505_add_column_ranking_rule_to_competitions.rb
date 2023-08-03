# frozen_string_literal: true

class AddColumnRankingRuleToCompetitions < ActiveRecord::Migration[7.0]
  def change
    add_column :competitions, :ranking_rule, :string, default: 'asc'
  end
end
