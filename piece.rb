class Piece
  attr_accessor :position
  attr_reader :color, :king

  def initialize(board, color, position, king=false)
    @color = color
    @board = board
    @position = position
    @king = king
  end

  def inspect
    "#{@color} #{@position} "  
  end

  def king_piece
    @king = true
  end

  def king?
    !!@king
  end

  def symbol
    if king?
      color == :black ? "♛ ".black.on_light_white : "♛ ".red.on_light_white
    else
      color == :black ? "● ".black.on_light_white : "● ".red.on_light_white
    end
  end

  def slide_moves
    transforms = [[-1,-1], [-1,1], [1,-1], [1,1]]
    king? ? max_distance = 8 : max_distance = 1
    new_positions = []
    
    transforms.each do |x,y|
      (1..max_distance).each do |distance|
        new_pos = [x * distance + position[0], y * distance + position[1]]
        break unless within_board?(new_pos) && @board.not_occupied?(new_pos)
        new_positions << new_pos
      end
    end
    new_positions
  end

  def jump_moves
    transforms = [[-2,-2], [-2,2], [2,-2], [2,2]]

    transforms.select! do |x,y| 
      new_pos = [x + position[0], y + position[1]]
      within_board?(new_pos) && @board.not_occupied?(new_pos)
    end

    transforms.select! do |x,y|   
      jump_over = [x/2 + position[0], y/2 + position[1]] 
      !@board.not_occupied?(jump_over) &&  @board[jump_over].color != @color 
    end
    transforms.map{ |x,y| [x + position[0], y + position[1]] }
  end

  def within_board?(pos)
    x,y = pos
    x >= 0 && y >= 0 && x < 8 && y < 8
  end
end