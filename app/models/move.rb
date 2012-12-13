class Move < ActiveRecord::Base
  attr_accessible :capturedPiece, :isCheck, :isCheckmate, :mover, :toX, :toY, :fromX, :fromY, :currentBoard
  
  serialize :currentBoard
  
  validates_presence_of :toX, :toY, :fromX, :fromY, :currentBoard
  
  belongs_to :game
  
  before_validation(:on => :create) do
     validate_move
     set_current_board
  end
  
  def validate_move
    # todo is the move valid?
    return true
  end
  
  # assumes move is valid
  def set_current_board
      previousBoard = self.game.current_board
      
      if previousBoard[self.toY][self.toX] != Game::Piece::EMPTY_SPACE
        self.capturedPiece = previousBoard[self.toY][self.toX]
      end
      
      previousBoard[self.toY][self.toX] = previousBoard[self.fromY][self.fromX]
      previousBoard[self.fromY][self.fromX] = Game::Piece::EMPTY_SPACE
      
      self.currentBoard = previousBoard
      
      if Game.isCheck?(previousBoard)
        self.isCheck = true
      elsif Game.isCheckmate?(previousBoard)
        self.isCheckmate = true
        
        g = self.game
        g.winner = self.mover
        g.save
      else
        self.isCheck = false
        self.isCheckmate = false
      end
      
      return true
  end
  
  def fromIndex
    self.fromX + 8 * self.fromY
  end
  
  def toIndex
    self.toX + 8 * self.toY
  end
  
  def to_hash
    {
      :current_board => self.currentBoard.flatten.to_json,
      :fromI => self.fromIndex,
      :toI => self.toIndex,
      :isCheck => self.isCheck,
      :isCheckmate => self.isCheckmate,
      :isCapture => !self.capturedPiece.nil?,
      :capturedPiece => self.capturedPiece,
      :player => self.mover,
      :isNewGame => false
    }
  end
  
end
