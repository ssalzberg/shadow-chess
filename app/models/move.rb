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
  
  def fromX=(x)
    self[:fromX] = self.player == Game::Player::ONE ? x : 8 - x
  end
  
  def fromY=(y)
    self[:fromY] = self.player == Game::Player::ONE ? y : 8 - y
  end
  
  def toX=(x)
    self[:toX] = self.player == Game::Player::ONE ? x : 8 - x
  end
  
  def toY=(y)
    self[:toY] = self.player == Game::Player::ONE ? y : 8 - y
  end
  
  def player
    self.mover ? Game::Player::TWO : Game::Player::ONE
  end
  
  def to_hash(player)
    {
      :currentBoard => Game.board_to_return_for_player(self.currentBoard,player),
      :movedPieceName => Game.pieceName(self.currentBoard[self.toY][self.toX]),
      :fromI => player == Game::Player::ONE ? self.fromIndex : 63 - self.fromIndex,
      :toI => player == Game::Player::ONE ? self.toIndex : 63 - self.toIndex,
      :isCheck => self.isCheck,
      :isCheckmate => self.isCheckmate,
      :isCapture => !self.capturedPiece.nil?,
      :capturedPieceName => Game.pieceName(self.capturedPiece),
      :capturedPiece => self.capturedPiece,
      :player => self.mover ? Game::Player::TWO : Game::Player::ONE,
      :isNewGame => false
    }
  end
  
end
