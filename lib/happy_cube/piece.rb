module HappyCube
  class Piece
    # Creates a HappyCube piece, by specifying
    # its edge configuration.
    # Pieces are 5x5 squares, with the middle
    # (3x3 part) filled.
    # The edges are jagged, that's why they are
    # represented using 0s (gaps) abd 1s (filled portion),
    # enumerated in clockwise order starting from the
    # top left corner.
    #
    # For example, a piece whose edges are:
    # [0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 1]
    # can be represented graphically like this:
    #
    #  █ █
    # ████
    #  ████
    # ████
    # █ █
    #
    def initialize(edges)
      validate! edges
      @edges = edges
      @rows = [
        [*@edges[0...CUBE_SIZE]],
        [@edges[15], 1, 1, 1, @edges[5]],
        [@edges[14], 1, 1, 1, @edges[6]],
        [@edges[13], 1, 1, 1, @edges[7]],
        [*@edges[8..12].reverse]
      ]
    end

    def self.create(edge_configuration)
      HappyCube::Piece.new edge_configuration.chars.map(&:to_i)
    end

    attr_reader :edges, :rows

    def edge(direction)
      case direction
      when :top
        @edges[0...CUBE_SIZE]
      when :bottom
        @edges[8...8 + CUBE_SIZE].reverse
      when :left
        [@edges[0]] + @edges[12..15].reverse
      when :right
        @edges[4...4 + CUBE_SIZE]        
      end
    end

    def corner(direction)
      case direction
      when :top_left
        @edges[0]
      when :top_right
        @edges[4]
      when :bottom_left
        @edges[12]
      when :bottom_right
        @edges[8]
      end
    end

    private

    def validate!(edges)
      fail InvalidPieceError, 'Edges cannot be nil' unless edges
      fail InvalidPieceError,
           'Invalid edge length. Must be 16.' unless edges.count == 16
    end

    @@without_edges = Piece.new([0] * 16)
    def self.without_edges
      @@without_edges
    end
  end

  class InvalidPieceError < Error
  end
end
