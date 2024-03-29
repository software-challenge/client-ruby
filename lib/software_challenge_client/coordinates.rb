# frozen_string_literal: true

# Einfache kartesische Koordinaten
class Coordinates
  include Comparable
  attr_reader :x, :y

  # Erstellt neue leere Koordinaten.
  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    x == other.x && y == other.y
  end

  # Gibt die Ursprungs-Koordinaten (0, 0) zurück.
  def self.origin
    Coordinates.new(0, 0)
  end

  # Konvertiert (x, y) in das doubled Koordinatensystem.
  # @param x [Integer] X-Koordinate aus dem odd-r System
  # @param y [Integer] Y-Koordinate aus dem odd-r System
  def self.oddr_to_doubled(c)
    self.oddr_to_doubled_int(c.x, c.y)
  end

  # Konvertiert c in das doubled Koordinatensystem.
  # @param c [Coordinates] Koordinaten aus dem odd-r System
  def self.oddr_to_doubled_int(x, y)
    Coordinates.new(x * 2 + y % 2, y)
  end

  # Konvertiert c in das odd-r Koordinatensystem.
  # @param c [Coordinates] Koordinaten aus dem doubled System
  def self.doubled_to_oddr(c)
    self.doubled_to_oddr_int(c.x, c.y)
  end

  # Konvertiert (x, y) in das doubled Koordinatensystem.
  # @param x [Integer] X-Koordinate aus dem doubled System
  # @param y [Integer] Y-Koordinate aus dem doubled System
  def self.doubled_to_oddr_int(x, y)
    Coordinates.new((x / 2.0).ceil() - y % 2, y)
  end

  def <=>(other)
    xComp = x <=> other.x
    yComp = y <=> other.y
    if xComp == 0
      yComp
    else
      xComp
    end
  end

  def +(other)
    Coordinates.new(x + other.x, y + other.y)
  end

  # Gibt eine textuelle Repräsentation der Koordinaten aus.
  def to_s
    "(#{x}, #{y})"
  end

  def inspect
    to_s
  end
end
