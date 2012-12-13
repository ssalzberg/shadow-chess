class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :winner
      t.integer :total_moves

      t.timestamps
    end
  end
end
