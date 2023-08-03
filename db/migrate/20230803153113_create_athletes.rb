# frozen_string_literal: true

class CreateAthletes < ActiveRecord::Migration[7.0]
  def change
    create_table :athletes do |t|
      t.string   :name

      t.timestamps
    end
  end
end
