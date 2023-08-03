# frozen_string_literal: true

class AddColumnStatusAndMaxAttemptsToCompetitions < ActiveRecord::Migration[7.0]
  def change
    add_column :competitions, :status, :integer, default: 0
    add_column :competitions, :max_attempts, :integer, default: 1
  end
end
