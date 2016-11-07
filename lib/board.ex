defmodule GameOfLife.Board do
  defstruct(
    size: {1,1}, # size of board {x,y}
    alive_cells: [], # list of tuples of alive cells e.g. [{1,1}, {5,2}].  Bottom left is 0,0
  )
end
