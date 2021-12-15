defmodule AOC2021.Day6 do
  import Enum
  import String, only: [split: 3, to_integer: 1]

  def iterate_counts([a, b, c, d, e, f, g, h, i]) do
    [b, c, d, e, f, g, h + a, i, a]
  end

  def input_format do
    :line
  end

  def run(input) do
    empty = 0..8 |> into(%{}, &{&1, 0})

    fish =
      input
      |> split(",", trim: true)
      |> map(&to_integer/1)

    fish_counts = Map.merge(empty, frequencies(fish)) |> Map.values()

    generations =
      Stream.unfold(fish_counts, fn x ->
        f = iterate_counts(x)
        {f, f}
      end)

    {generations |> at(80 - 1) |> sum, generations |> at(256 - 1) |> sum}
  end
end
