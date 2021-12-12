defmodule AOC2021 do
  import Enum

  def countIncreases(xs) do
    xs
    |> chunk_every(2, 1, :discard)
    |> count(fn [a, b] -> a < b end)
  end

  def day1 do
    numbers =
      File.read!("day1_input")
      |> String.split("\n", trim: true)
      |> map(&String.to_integer/1)

    numbers
    |> countIncreases
    |> IO.inspect()

    numbers
    |> chunk_every(3, 1, :discard)
    |> map(&sum/1)
    |> countIncreases
    |> IO.inspect()
  end
end

AOC2021.day1()
