defmodule AOC2021.Day7 do
  import Enum
  import String, only: [split: 3, to_integer: 1]

  def solution1_cost(crabs, n) do
    crabs |> reduce(0, fn x, acc -> acc + abs(x - n) end)
  end

  def triang(n) do
    div(n * (n + 1), 2)
  end

  def solution2_cost(crabs, n) do
    crabs |> reduce(0, fn x, acc -> acc + triang(abs(x - n)) end)
  end

  def input_format do :line end
  def run(input) do
    crabs =
      input
      |> split(",", trim: true)
      |> map(&to_integer/1)

    solutions = to_list(min(crabs)..max(crabs)) |> map(&solution1_cost(crabs, &1))
    a = min(solutions)

    solutions = to_list(min(crabs)..max(crabs)) |> map(&solution2_cost(crabs, &1))
    b = min(solutions)
    {a, b}
  end
end

