require 'colorize'
require './piece.rb'

class Board
	def initialize(grid = blank_grid)
		@grid = grid
		fill_grid
	end

	def render_grid
		count = 0
		(0...8).each {|x| print " #{x}" }
		puts ""
		@grid.each_with_index do |row, row_index|
			print "#{row_index}"
			row.each do |tile|
				printed = tile.nil? ? "  " : " #{tile.symbol}"
				if (count + row_index) % 2 == 0
					print printed.on_light_white
				else
					print printed.on_light_black
				end
				count += 1
			end
			puts ""
		end
	end


	def blank_grid
		Array.new(8) { Array.new(8) }
	end

	def fill_grid
		(0..2).each do |x|
			(0...8).each do |y|
			  @grid[x][y]  = Piece.new(self, :red, [x, y]) if (x + y) % 2 == 0
			end
		end

		(5...8).each do |x|
			(0...8).each do |y|
				@grid[x][y] = Piece.new(self, :black, [x, y]) if (x + y) % 2 == 0  
			end
		end
	end

	def [](pos)
		x,y = pos
		@grid [x][y]
	end

	def []=(pos_to, piece_from)
		x,y = pos_to
		@grid[x][y] = piece_from
		piece_from.position = pos_to unless piece_from.nil?

	end
	
	def not_occupied?(pos)
		x,y = pos
		@grid[x][y] == nil
	end

	def perform_slide(pos_from, pos_to)
		unless self[pos_from].slide_moves.include?(pos_to)
			raise InvalidMoveError, "invalid move!" 
		end
		self[pos_from], self[pos_to] = nil, self[pos_from]
	end

	def perform_jump(pos_from, pos_to)
		unless self[pos_from].jump_moves.include?(pos_to)
			raise InvalidMoveError, "invalid move!"
		end
		self[pos_from], self[pos_to] = nil, self[pos_from]
		captured_pos = [(pos_from[0] + pos_to[0])/2, (pos_from[1] + pos_to[1])/2]
		self[captured_pos] = nil
	end

	def valid_move_seq?
	end


	def perform_moves!(move_sequence, first_move = true)	
		pos_from = move_sequence.shift
		pos_to = move_sequence.first

		if self[pos_from].slide_moves.include?(pos_to)
			p "we reached here"
			raise InvalidMoveError, "invalid move!" unless first_move == true
			perform_slide(pos_from, pos_to)
		else
			p "why did we jump..."
			perform_jump(pos_from, pos_to)
		end
		
		perform_moves!(move_sequence, false) unless move_sequence.length == 1
		
	end

	def valid_move_seq?(move_sequence)
		begin
			board.dup.perform_moves!(move_sequence)
			true
		rescue
			p "there was a problem"
			false
		end
	end

	def dup
		board_copy = Board.new
		grid_copy = []
		
		@grid.each do |row|
			row_copy = []
			row.each do |tile|
				tile.nil ? row_copy << nil : row_copy << Piece.new( board_copy, tile.color, tile.position)
			end
			grid_copy << row_copy
		end

		board_copy.grid = grid_copy
		board_copy
	end
end

class InvalidMoveError < Exception
end

b = Board.new

# p "perform_slide_test:"
# b.perform_slide([2,2],[3,3])
# p b
# p b[[3,3]].position
#● ♛ ♕ ○




p "perform_valid_move_seq_test:"
b = Board.new
b.render_grid
#● ♛ ♕ ○
b.perform_slide([2,0],[3,1])
b.perform_slide([3,1],[4,2])

b.render_grid

b.perform_slide([2,2],[3,3])
b.perform_slide([3,3],[4,4])


b.perform_slide([5,5],[4,6])

b.render_grid


move_sequence = [[5,1], [3,3]]
b.valid_move_seq?(move_sequence)

p b



