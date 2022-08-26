# encoding: utf-8
# frozen_string_literal: true

# Ein Feld des Spielfelds. Ein Spielfeld ist durch die Koordinaten eindeutig
# identifiziert.
class Field
  # @!attribute [r] coordinates
  # @return [Coordinates] die X-Y-Koordinaten des Feldes
  attr_reader :coordinates

  # @!attribute [rw] piece
  # @return [Piece] das Piece auf diesem Feld, falls vorhanden, sonst nil
  attr_accessor :piece

  # @!attribute [rw] fishes
  # @return [Integer] die Menge an Fischen auf dem Feld
  attr_accessor :fishes

  # Erstellt ein neues leeres Feld.
  #
  # @param x [Integer] X-Koordinate
  # @param y [Integer] Y-Koordinate
  # @param color [Color] Farbe des Spielsteins, der das Feld überdeckt, nil falls kein Spielstein es überdeckt
  def initialize(x, y, piece = nil, fishes = 0)
    @piece = piece
    @fishes = fishes
    @coordinates = Coordinates.new(x, y)
  end

  # Vergleicht zwei Felder. Felder sind gleich, wenn sie gleiche Koordinaten und
  # den gleichen Spielstein haben.
  # @return [Boolean] true bei Gleichheit, sonst false.
  def ==(other)
    !other.nil? && coordinates == other.coordinates && piece == other.piece
  end

  # @return [Integer] X-Koordinate des Felds
  def x
    coordinates.x
  end

  # @return [Integer] Y-Koordinate des Felds
  def y
    coordinates.y
  end

  # @return [Team] Team des Pieces auf dem Feld
  def team
    if piece.nil?
      nil
    else
      piece.color.to_t
    end
  end

  # @return [Boolean] true, wenn auf dem Feld kein Spielstein und keine Fische sind, sonst false
  def empty?
    piece.nil? && fishes == 0
  end

  # @return [Boolean] true, wenn auf dem Feld kein Spielstein und mindestens ein Fisch ist, sonst false
  def free?
    piece.nil? && fishes != 0
  end

  # @return [String] Textuelle Darstellung des Feldes.
  def to_s
    empty? ? '__' : piece.to_ss
  end
end
