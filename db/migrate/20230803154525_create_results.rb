# frozen_string_literal: true

class CreateResults < ActiveRecord::Migration[7.0]
  def change
    create_table   :results do |t|
      t.references :competition, null: false, foreign_key: true
      t.references :athlete, null: false, foreign_key: true
      t.float      :value

      t.timestamps
    end
  end
end
