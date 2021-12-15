defmodule AOC2021.Day5 do
  import Enum
  import String, only: [split: 3, to_integer: 1]

  defmodule Point do
    @enforce_keys [:x, :y]
    defstruct [:x, :y]

    def parse(f) do
      [x, y] = split(f, ",", parts: 2) |> map(&to_integer/1)
      %Point{x: x, y: y}
    end

    def add(a, b) do
      %Point{x: a.x + b.x, y: a.y + b.y}
    end

    def sub(a, b) do
      %Point{x: a.x - b.x, y: a.y - b.y}
    end

    def unit(a) do
      %Point{
        x:
          if a.x == 0 do
            0
          else
            div(a.x, abs(a.x))
          end,
        y:
          if a.y == 0 do
            0
          else
            div(a.y, abs(a.y))
          end
      }
    end
  end

  def direction(a, b) do
    Point.unit(Point.sub(b, a))
  end

  def is_straight({a, b}) do
    a.x == b.x || a.y == b.y
  end

  def points_between({a, b}) do
    if a == b do
      [a]
    else
      [a | points_between({Point.add(a, direction(a, b)), b})]
    end
  end

  def count_intersections(lines) do
    points =
      lines
      |> map(&points_between/1)
      |> reduce(Map.new(), fn x, map ->
        x |> reduce(map, fn x, map -> Map.update(map, x, 1, &(&1 + 1)) end)
      end)

    points |> count(fn {_, x} -> x > 1 end)
  end

  def input_format do
    :lines
  end

  def run(input) do
    lines =
      for line <- input do
        [a, b] = split(line, " -> ", trim: true, parts: 2) |> map(&Point.parse/1)
        {a, b}
      end

    a = lines |> filter(&is_straight/1) |> count_intersections
    b = lines |> count_intersections
    {a, b}
  end
end
