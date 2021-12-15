defmodule AOC2021 do
  @moduledoc """
  Documentation for `Aoc2021`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc2021.hello()
      :world

  """
  def get_input(day, true) do
    File.read!("inputs/day#{day}_test")
  end

  def get_input(day, false) do
    File.read!("inputs/day#{day}_input")
  end

  def ints(input) do
    Enum.map(input, &String.to_integer/1)
  end

  def run(day, test \\ false) do
    m = Module.safe_concat(AOC2021, "Day#{day}")
    input = get_input(day, test)

    input =
      case apply(m, :input_format, []) do
        nil ->
          input

        :lines ->
          String.split(input, "\n", trim: true)

        :line ->
          [line] = String.split(input, "\n", trim: true)
          line

        :sections ->
          String.split(input, "\n\n", trim: true)
      end

    apply(m, :run, [input])
  end
end
