class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.string :mover
      t.integer :toX
      t.integer :toY
      t.string :capturedPiece
      t.boolean :isCheck
      t.boolean :isCheckmate

      t.timestamps
    end
  end
end
