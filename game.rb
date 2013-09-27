require './board.rb'
require './player.rb'
require 'debugger'


class Game
	def initialize
		@board = Board.new
		@red = Player.new(:red)
		@black = Player.new(:black)
		@current_player = @black
	end

	def play
		until game_over?
			@current_player == @red ? @current_player = @black : @current_player = @red
			begin
				@board.render_grid
				move = @current_player.choose_move
				other_players_piece(move)
				@board.perform_moves(move)
			rescue
				puts "Invalid Move"
				retry
			end
		end
		"Congratulations, #{@current_player.color.to_s.capitalize} has won!"
	end

	def other_players_piece(move)
		raise "not your piece" unless @board[move.first].color == @current_player.color
	end
 
	def game_over?
		@board.red_count == 0 || @board.black_count == 0
	end
end


class InvalidMoveError < Exception
end


g = Game.new
g.play