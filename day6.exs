defmodule AOC2021 do
  import Enum
  import String, only: [split: 3, to_integer: 1]

  def iterate(fish) do
    {fish, count} = fish |> map_reduce(0, fn
      0, acc -> {6, acc + 1}
      n, acc -> {n - 1, acc}
    end)
    fish ++ (Stream.cycle([8]) |> take(count))
  end

  def day6 do
    fish = File.read!("day6_input")
    |> split("\n", trim: true) |> List.first() |> split(",", trim: true) |> map(&to_integer/1)
    generations = Stream.unfold(fish, fn x ->
      f = iterate(x)
      {f, f}
    end)
    IO.inspect(generations |> at(80 - 1) |> length)

  end
end

AOC2021.day6()
