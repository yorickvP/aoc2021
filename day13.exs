defmodule AOC2021 do
  import Enum
  import String, only: [split: 3, to_integer: 1]

  def mirror({:x, n}, {a, b}) do
    cond do
      n > a -> {a, b}
      n < a -> {n - (a - n), b}
    end
  end

  def mirror({:y, n}, {a, b}) do
    cond do
      n > b -> {a, b}
      n < b -> {a, n - (b - n)}
    end
  end

  def day13 do
    [points, folds] =
      File.read!("day13_input")
      |> split("\n\n", trim: true)

    points =
      points
      |> split("\n", trim: true)
      |> map(fn x -> x |> split(",", parts: 2) |> map(&to_integer/1) end)
      |> map(fn [x, y] -> {x, y} end)
      |> into(MapSet.new())

    folds =
      folds
      |> split("\n", trim: true)
      |> map(fn
        <<_::binary-size(11), ?x, ?=, rest::binary>> -> {:x, to_integer(rest)}
        <<_::binary-size(11), ?y, ?=, rest::binary>> -> {:y, to_integer(rest)}
      end)

    # part 1
    points |> MapSet.new(&mirror(List.first(folds), &1)) |> MapSet.size() |> IO.inspect()
    # part 2
    folded = folds |> reduce(points, fn x, acc -> MapSet.new(acc, &mirror(x, &1)) end)

    {max_x, max_y} =
      folded |> reduce({0, 0}, fn {a, b}, {x, y} -> {Kernel.max(a, x), Kernel.max(b, y)} end)

    for y <- 0..max_y, into: "" do
      for x <- 0..max_x, into: "" do
        if folded |> MapSet.member?({x, y}) do
          "#"
        else
          " "
        end
      end <> "\n"
    end
    |> IO.write()
  end
end

AOC2021.day13()
