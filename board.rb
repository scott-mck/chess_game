require_relative 'stepping_piece'
require_relative 'sliding_piece'
require_relative 'pawn'

class Board
  LAYOUT = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

  attr_reader :pieces, :grid

  def initialize
    @pieces = []
    @grid = Array.new(8) { Array.new(8) }
    # set_up_pieces
  end

  def []=(pos, piece)
    @grid[pos.first][pos.last] = piece
  end

  def set_up_pieces
    8.times do |column|
      @pieces << Pawn.new(self, [1, column], :black)
      @pieces << Pawn.new(self, [6, column], :white)
      @pieces << LAYOUT[column].new(self, [0, column], :black)
      @pieces << LAYOUT[column].new(self, [7, column], :white)
    end

    @pieces.each do |piece|
      self[piece.pos] = piece
    end
  end

  def occupied?(pos)
    !!piece_at(pos)
  end

  def piece_at(pos)
    @grid[pos.first][pos.last]
  end

  def move(start_pos, end_pos)
    piece = piece_at(start_pos)
    if piece.nil? || !piece.valid_moves.include?(end_pos)
      raise "Invalid move"
    end

    self[start_pos] = nil
    self[end_pos] = piece
    piece.pos = end_pos
  end

  def set_piece_at(start_pos, end_pos)
    piece = piece_at(start_pos)
    self[start_pos] = nil
    self[end_pos] = piece
    piece.pos = end_pos
  end

  def checkmate?(color)
    in_check?(color) && get_pieces_of(color).all? do |piece|
      piece.valid_moves.empty?
    end
  end

  def in_check?(color)
    king_pos = @pieces.select do |piece|
      piece.is_a?(King) && piece.color == color
    end[0].pos
    get_pieces_of(:white == color ? :black : :white).any? do |piece|
      piece.moves.include?(king_pos)
    end
  end

  def get_pieces_of(color)
    @pieces.select { |piece| piece.color == color }
  end

  def deep_dup
    new_board = Board.new
    @pieces.each do |piece|
      new_piece = piece.class.new(new_board, piece.pos, piece.color)
      new_board[piece.pos] = new_piece
      new_board.pieces << new_piece
    end

    new_board
  end

  def render
    grid.each do |row|
      row_mapped = row.map do |el|
        if el.nil?
          ' '
        else
          el
        end
      end
      puts row_mapped.join(' ')
    end
  end
end

# def t(code)
#   letter, number = code.split('')
#   number = 8 - number.to_i
#   letter = ('a'..'h').to_a.index(letter)
#   [number, letter]
# end
