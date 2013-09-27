class Player
  attr_reader :color
  def initialize(color)
    @color = color
  end

  def choose_move
    begin   
      puts "Where would #{color.to_s.capitalize} like to move? format: x,y x,y ..."
      moves = gets.chomp.split(' ')
      moves.map! { |string| string.split(',').map(&:to_i) }
    rescue
      puts "Invalid input"
      retry
    end
  end
end