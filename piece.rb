class Piece
  attr_accessor :pos
  attr_reader :color  #:moved, :board

  STRAIGHT = [[1, 0], [0, 1], [-1, 0], [0, -1]]
  DIAGONAL = [[1, 1], [1, -1], [-1, 1], [-1, -1]]

  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
    @moved = false
  end

  def moves
    raise "Not yet implemented"
  end

  def symbol
    raise "Not yet implemented"
  end

  def single_step(position, dir)
    position.map.with_index do |coordinate, idx|
      coordinate + dir[idx]
    end
  end

  def valid_moves
    moves.reject do |move|
      new_board = @board.deep_dup
      new_board.move(@pos, move)
      new_board.in_check?(@color)
    end
  end

  def valid_position?(position)
    return false unless position.all? { |coord| coord.between?(0,7) }
    return true unless @board.occupied?(position)

    @color != @board.piece_at(position).color
  end
end
