# frozen_string_literal: true

# Read http://betterspecs.org/ for suggestions writing good specs.

RSpec.describe Piece do
  subject(:piece) { Piece.new }

  it 'has a sensible string representation' do
    expect(Piece.new(Team::ONE).to_s).to eq("ONE at (0, 0)")
    expect(Piece.new(Team::ONE, Coordinates.new(3,4)).to_s).to eq("ONE at (3, 4)")
  end

  it 'has coordinates as coords' do
    p = Piece.new(
      Team::ONE,
      Coordinates.new(7, 3)
    )
    expect(p.coords).to be_a(Coordinates)
  end
end
