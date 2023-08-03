class CreateCompetitionAthletes < ActiveRecord::Migration[7.0]
  def change
    create_table :competition_athletes do |t|
      t.references :competition, null: false, foreign_key: true
      t.references :athlete, null: false, foreign_key: true

      t.timestamps
    end
  end
end
