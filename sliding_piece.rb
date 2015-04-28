require_relative 'piece'

class SlidingPiece < Piece
  STRAIGHT = [[1, 0], [0, 1], [-1, 0], [0, -1]]
  DIAGONAL = [[1, 1], [1, -1], [-1, 1], [-1, -1]]

  def moves
    moves_array = []
    move_dirs.each do |direction|
      moves_array += slide(direction)
    end
    moves_array
  end

  def slide(dir)
    moves_array
    new_position = slide_once(@pos, dir)
    while valid_position?(new_position)
      moves_array << new_position
      new_position = slide_once(new_position, dir)
    end

    moves_array
  end

  def slide_once(position, dir)
    position.map.with_index do |coordinate, idx|
      coordinate + dir[idx]
    end
  end
end

class Queen < SlidingPiece
  def move_dirs
    STRAIGHT + DIAGONAL
  end
end

class Bishop < SlidingPiece
  def move_dirs
    DIAGONAL
  end
end

class Rook < SlidingPiece
  def move_dirs
    STRAIGHT
  end
end
