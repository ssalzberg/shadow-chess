class AddCurrentBoardToMove < ActiveRecord::Migration
  def change
    add_column :moves, :currentBoard, :text
    add_column :moves, :fromX, :integer
    add_column :moves, :fromY, :integer
    remove_column :moves, :capturedPiece
    add_column :moves, :capturedPiece, :integer
    remove_column :moves, :mover
    add_column :moves, :mover, :boolean
    remove_column :games, :winner
    add_column :games, :winner, :boolean
  end
end
