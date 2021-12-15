defmodule AOC2021.Day1 do
  import Enum

  def countIncreases(xs) do
    xs
    |> chunk_every(2, 1, :discard)
    |> count(fn [a, b] -> a < b end)
  end

  def input_format do :lines end
  def run(input) do
    numbers = AOC2021.ints(input)

    a = numbers
    |> countIncreases

    b = numbers
    |> chunk_every(3, 1, :discard)
    |> map(&sum/1)
    |> countIncreases

    {a, b}
  end
end

