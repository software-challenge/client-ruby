# encoding: utf-8
# frozen_string_literal: true

require_relative './util/constants'
require_relative 'game_state'
require_relative 'field'

# Ein Spielbrett fuer Ostseeschach 
class Board
  include Constants

  # @!attribute [r] fields
  # @note Besser über die {#field} Methode auf Felder zugreifen.
  # @return [Array<Array<Field>>] Ein Feld wird an der Position entsprechend
  #   seiner x und y Coordinates im Array gespeichert.
  attr_reader :fields

  # --- Init ------------------------------------------------------------

  # Erstellt ein neues leeres Spielbrett.
  def initialize(fields = [])
    @fields = Board.empty_game_field
    fields.each { |f| add_field(f) }
  end

  # @return [Array] leere Felder entsprechend des Spielbrettes angeordnet
  def self.empty_game_field
    (0...BOARD_SIZE).to_a.map do |x|
      (0...BOARD_SIZE).to_a.map do |y|
        Field.new(x, y)
      end
    end
  end

  # Entfernt alle Felder des Spielfeldes
  def clear
    @fields = []
  end

  # --- Field Access ------------------------------------------------------------

  # Fügt ein Feld dem Spielbrett hinzu. Das übergebene Feld ersetzt das an den
  # Koordinaten bestehende Feld.
  #
  # @param field [Field] Das einzufügende Feld.
  def add_field(field)
    @fields[field.x][field.y] = field
  end

  # Zugriff auf die Felder des Spielfeldes
  #
  # @param x [Integer] Die X-Koordinate des Feldes.
  # @param y [Integer] Die Y-Koordinate des Feldes.
  # @return [Field] Das Feld mit den gegebenen Koordinaten. Falls das Feld nicht
  #                 exisitert, wird nil zurückgegeben.
  def field(x, y)
    fields.dig(x, y) # NOTE that #dig requires ruby 2.3+
  end

  # Zugriff auf die Felder des Spielfeldes über ein Koordinaten-Paar.
  #
  # @param coords [Coordinates] X- und Y-Koordinate als Paar, sonst wie
  # bei {Board#field}.
  #
  # @return [Field] Wie bei {Board#field}.
  #
  # @see #field
  def field_at(coords)
    field(coords.x, coords.y)
  end

  # @return [Array] Liste aller Felder
  def field_list
    @fields.flatten.reject(&:nil?)
  end

  # @param coords [Coordinates] Die Koordinaten des Felds
  # @return Das Feld an den gegebenen Koordinaten
  def [](coords)
    field_at(coords)
  end

  def fields_of_team(team)
    fields = []

    (0...BOARD_SIZE).to_a.map do |x|
      (0...BOARD_SIZE).to_a.map do |y|
        f = field(x,y)
        if (!f.piece.nil? && f.piece.team == team)
          fields << f
        end
      end
    end

    fields
  end

  # @param field [Field] Das eingabe Feld
  # @return Die Felder um dem gegebenen Feld
  def neighbors_of(field) 
    coords = []
    c = Coordinates.oddr_to_doubled(field.coords)

    Direction.each { |d|
      disp = d.to_vec()

      x = c.x + disp.x
      y = c.y + disp.y

      oddr_coords = Coordinates.doubled_to_oddr_int(x, y)
      if !in_bounds?(oddr_coords)
        next
      end

      coords.push(oddr_coords)
    }

    coords.map{ |x| self.field_at(x) }.to_a
  end

  # --- Other ------------------------------------------------------------

  # @param coords [Coordinates] Die zu untersuchenden Koordinaten
  # @return [Boolean] Ob die gegebenen Koordinaten auf dem Board liegen oder nicht
  def in_bounds?(coords)
    coords.x >= 0 && coords.y >= 0 && coords.x < BOARD_SIZE && coords.y < BOARD_SIZE
  end

  # Vergleicht zwei Spielbretter. Gleichheit besteht, wenn zwei Spielbretter die
  # gleichen Felder enthalten.
  def ==(other)
    field_list == other.field_list
  end

  # @return eine unabhaengige Kopie des Spielbretts
  def clone
    Marshal.load(Marshal.dump(self))
  end

  # Gibt eine textuelle Repräsentation des Spielbrettes aus.
  def to_s
    "\n" +
      (0...BOARD_SIZE).to_a.map do |y|
        (0...BOARD_SIZE).to_a.map do |x|
          @fields[x][y].to_s
        end.join(' ')
      end.join("\n")
  end
end
