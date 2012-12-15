class Game < ActiveRecord::Base
  attr_accessible :total_moves, :winner
  
  has_many :moves
  
  module Player
    ONE = 0
    TWO = 1
  end
  
  module Color
    WHITE = 0
    BLACK = 1
  end
  
  module Piece
     EMPTY_SPACE = 0

     WHITE_PAWN1 = 1
     WHITE_PAWN2 = 2
     WHITE_PAWN3 = 3
     WHITE_PAWN4 = 4
     WHITE_PAWN5 = 5
     WHITE_PAWN6 = 6
     WHITE_PAWN7 = 7
     WHITE_PAWN8 = 8
     WHITE_ROOK1 = 9
     WHITE_ROOK2 = 10
     WHITE_KNIGHT1 = 11
     WHITE_KNIGHT2 = 12
     WHITE_BISHOP1 = 13
     WHITE_BISHOP2 = 14
     WHITE_QUEEN = 15
     WHITE_KING = 16

     BLACK_PAWN1 = 17
     BLACK_PAWN2 = 18
     BLACK_PAWN3 = 19
     BLACK_PAWN4 = 20
     BLACK_PAWN5 = 21
     BLACK_PAWN6 = 22
     BLACK_PAWN7 = 23
     BLACK_PAWN8 = 24
     BLACK_ROOK1 = 25
     BLACK_ROOK2 = 26
     BLACK_KNIGHT1 = 27
     BLACK_KNIGHT2 = 28
     BLACK_BISHOP1 = 29
     BLACK_BISHOP2 = 30
     BLACK_QUEEN = 31
     BLACK_KING = 32
  end
  
  INITIAL_BOARD = [
    [Piece::WHITE_ROOK1,  Piece::WHITE_KNIGHT1,  Piece::WHITE_BISHOP1,  Piece::WHITE_QUEEN,  Piece::WHITE_KING,   Piece::WHITE_BISHOP2,  Piece::WHITE_KNIGHT2,   Piece::WHITE_ROOK2],
    [Piece::WHITE_PAWN1,  Piece::WHITE_PAWN2,    Piece::WHITE_PAWN3,    Piece::WHITE_PAWN4,  Piece::WHITE_PAWN5,  Piece::WHITE_PAWN6,    Piece::WHITE_PAWN7,     Piece::WHITE_PAWN8],
    [Piece::EMPTY_SPACE,  Piece::EMPTY_SPACE,    Piece::EMPTY_SPACE,    Piece::EMPTY_SPACE,  Piece::EMPTY_SPACE,  Piece::EMPTY_SPACE,    Piece::EMPTY_SPACE,     Piece::EMPTY_SPACE],
    [Piece::EMPTY_SPACE,  Piece::EMPTY_SPACE,    Piece::EMPTY_SPACE,    Piece::EMPTY_SPACE,  Piece::EMPTY_SPACE,  Piece::EMPTY_SPACE,    Piece::EMPTY_SPACE,     Piece::EMPTY_SPACE],
    [Piece::EMPTY_SPACE,  Piece::EMPTY_SPACE,    Piece::EMPTY_SPACE,    Piece::EMPTY_SPACE,  Piece::EMPTY_SPACE,  Piece::EMPTY_SPACE,    Piece::EMPTY_SPACE,     Piece::EMPTY_SPACE],
    [Piece::EMPTY_SPACE,  Piece::EMPTY_SPACE,    Piece::EMPTY_SPACE,    Piece::EMPTY_SPACE,  Piece::EMPTY_SPACE,  Piece::EMPTY_SPACE,    Piece::EMPTY_SPACE,     Piece::EMPTY_SPACE],
    [Piece::BLACK_PAWN1,  Piece::BLACK_PAWN2,    Piece::BLACK_PAWN3,    Piece::BLACK_PAWN4,  Piece::BLACK_PAWN5,  Piece::BLACK_PAWN6,    Piece::BLACK_PAWN7,     Piece::BLACK_PAWN8],
    [Piece::BLACK_ROOK1,  Piece::BLACK_KNIGHT1,  Piece::BLACK_BISHOP1,  Piece::BLACK_QUEEN,  Piece::BLACK_KING,   Piece::BLACK_BISHOP2,  Piece::BLACK_KNIGHT2,   Piece::BLACK_ROOK2]  
  ]
  
  def current_board
    if self.moves.count == 1
      self.moves.last.currentBoard
    else
      INITIAL_BOARD
    end
  end
  
  def self.current
    Game.last
  end
  
  def self.isCheck?(board)
    return false # todo
  end
  
  def self.isCheckmate?(board)
    return false
  end
  
  def over?
    !self.winner.nil?
  end
  
  def self.pieceName(pieceNumber)
    return "" if pieceNumber.nil? 
    Game.const_get("Piece").constants.map { |s| s.to_s.gsub(/((WHITE|BLACK)_)|[0-9]/,"") }[pieceNumber].downcase
  end
  
  def self.board_to_return_for_player(board,player)
    if player == Player::ONE 
      return board.flatten
    else
      swappedBoard = INITIAL_BOARD
      
      4.times do |y|
        8.times do |x|
          swappedBoard[y][x] = board[7-y][x]
          swappedBoard[7-y][x] = board[y][x]
        end
      end
      
      return swappedBoard.reverse.flatten
    end
  end
  
  def to_hash(player)
    if self.moves.count > 0
      return self.moves.last.to_hash(player)
    else
      {
        :current_board => Game.board_to_return_for_player(INITIAL_BOARD,player),
        :isNewGame => true,
        :player => Player::ONE
      }
    end
  end
end
