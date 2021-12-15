defmodule AOC2021.Day3 do
  import Enum

  def count_bits(bitset) do
    %{0 => a, 1 => b} = Map.merge(%{0 => 0, 1 => 0}, frequencies(bitset))

    cond do
      a > b -> 0
      a < b -> 1
      a == b -> 1
    end
  end

  def part1(bits) do
    res =
      bits
      |> zip_with(& &1) # transpose
      |> map(&count_bits/1)

    gamma = Integer.undigits(res, 2)
    epsilon = Integer.undigits(map(res, &(1 - &1)), 2)
    {gamma, epsilon}
  end

  def part2(bits, fun) do
    heads = bits |> map(fn {[h | _], _} -> h end)
    mcv = fun.(heads)
    filtered = for {[^mcv | t], n} <- bits, do: {t, n}

    case filtered do
      [{_, n}] -> n
      _ -> part2(filtered, fun)
    end
  end

  def input_format do :lines end
  def run(input) do
    bits =
      input
      |> map(fn x -> map(String.split(x, "", trim: true), &String.to_integer/1) end)

    {gamma, epsilon} = part1(bits)
    numbers = bits |> map(&Integer.undigits(&1, 2))
    oxy = part2(zip(bits, numbers), &count_bits/1)
    co2 = part2(zip(bits, numbers), &(1 - count_bits(&1)))
    {gamma * epsilon, oxy * co2}
  end
end

