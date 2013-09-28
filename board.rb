require 'colorize'
require './piece.rb'

class Board
  attr_accessor :grid
  attr_reader :red_count, :black_count
  
  def initialize(grid = blank_grid)
    @grid = grid
    fill_grid
    @black_count = 12
    @red_count = 12
  end

  def blank_grid
    Array.new(8) { Array.new(8) }
  end

  def fill_grid
    (0...3).each { |x| fill_row(x, :red) }
    (5...8).each { |x| fill_row(x, :black) }
  end

  def fill_row(x, color)
    (0...8).each do |y|
      @grid[x][y] = Piece.new(self, color, [x, y] ) if (x + y ) % 2 == 0
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
    self[pos_from], self[pos_to] = nil, self[pos_from]
  end

  def perform_jump(pos_from, pos_to)
    self[pos_from], self[pos_to] = nil, self[pos_from]
    captured_pos = [(pos_from[0] + pos_to[0])/2, (pos_from[1] + pos_to[1])/2]
    self[captured_pos] = nil
    self[captured_pos].color == :black ? @black_count -= 1 : @red_count -=1 
  end

  def perform_moves(move_seq)
    raise "Not a valid move sequence" unless valid_move_seq?(move_seq)
    perform_moves!(move_seq)
  end

  def valid_move_seq?(move_seq)
    begin
      copy = self.dup
      copy.perform_moves!(move_seq)
      return true
    rescue InvalidMoveError => e
      puts e.message
      return false
    end
  end

  def perform_moves!(move_seq)
    start = move_seq[0]
    first_move = move_seq[1]
    if self[start].jump_moves.include?(first_move)
      (0..move_seq.length - 2).each do |index|
        pos_from, pos_to = move_seq[index], move_seq[index + 1]
        perform_jump(pos_from, pos_to)
        nil
      end
      last_pos = move_seq.last
      raise "You must make all jumps!" unless self[last_pos].jump_moves.empty?

    elsif self[start].slide_moves.include?(first_move)
      raise "Not a valid slide." unless move_seq.length == 2
      pos_from, pos_to = move_seq.first, move_seq.last
      perform_slide(pos_from, pos_to)
      nil
    else
      raise "Not a valid move."
    end
    king_piece(move_seq)
  end

  def king_piece(move_seq)
    if self[move_seq.last].color == :black
      self[move_seq.last].king_piece if move_seq.map(&:first).include?(0)
    else
      self[move_seq.last].king_piece if move_seq.map(&:first).include?(7)
    end
  end

  def dup
    board_copy = Board.new
    grid_copy = []
    
    @grid.each do |row|
      row_copy = []
      row.each do |tile|
        if tile.nil?
          row_copy << nil
        else
          row_copy << Piece.new( board_copy, tile.color, tile.position, tile.king)
        end
      end
      grid_copy << row_copy
    end

    board_copy.grid = grid_copy
    board_copy
  end

def render_grid
    count = 0
    (0...8).each {|x| print " #{x}" }
    puts ""
    @grid.each_with_index do |row, row_index|
      print "#{row_index}"
      row.each do |tile|
        printed = tile.nil? ? "  " : "#{tile.symbol}"
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
end