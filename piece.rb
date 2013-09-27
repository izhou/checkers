class Piece
	attr_accessor :position
	attr_reader :color

	def initialize(board, color, position)
		@color = color
		@board = board
		@position = position
		@king = false
	end

	def king
		@king = true
	end

	def king?
		@king == true
	end


	def symbol
		if king?
			color == :black ? "♛".black.on_light_white : "♛".red.on_light_white
		else
			color == :black ? "●".black.on_light_white : "●".red.on_light_white
		end
	end

	def inspect
		"#{@color} #{@position} "  
	end

	def slide_moves
		transforms = [[-1,-1], [-1,1], [1,-1], [1,1]]
		new_pos = transforms.map!{ |x,y| [x + position[0], y + position[1]] }
		new_pos.select { |pos| within_board?(pos) && @board.not_occupied?(pos) }
	end

	def jump_moves
		transforms = [[-2,-2], [-2,2], [2,-2], [2,2]]
		transforms.select! {|x,y| within_board?([x + position[0], y + position[1]]) }
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

class KingPiece
end