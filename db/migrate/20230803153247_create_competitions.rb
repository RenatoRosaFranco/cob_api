# frozen_string_literal: true

class CreateCompetitions < ActiveRecord::Migration[7.0]
  def change
    create_table :competitions do |t|
      t.string   :name
      t.string   :unit

      t.timestamps
    end
  end
end
