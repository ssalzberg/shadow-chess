class GamesController < ApplicationController

  def new
    @game = Game.create!
    json_success and return
  end
  
  def move
    @game = Game.current
    
    if @game.over?
      json_fail("Game Over","Reset pieces...") and return
    end
    
    fromI = params[:fromI].to_i
    toI = params[:toI].to_i
    
    fromX = fromI%8
    fromY = (fromI/8).to_i
    
    toX = toI%8
    toY = (toI/8).to_i
    
    m = @game.moves.new({
      :fromX => fromX,
      :fromY => fromY,
      :toX => toX,
      :toY => toY,
      :mover => params[:mover].to_i == 0 ? false : true
    })
    
    if m.save!
      json_success and return
    else
      json_fail("Error...","Please try again") and return
    end
  end
  
  def last_move
    @game = Game.current
    json_success and return
  end
  
  private
  
  def json_fail(msg1,msg2)
    render :json => {:success => false, :msg1 => msg1, :msg2 => msg2}.to_json
  end
  
  def json_success
    render :json => {:success => true, :status => Game.current.to_hash}.to_json
  end
  
end
