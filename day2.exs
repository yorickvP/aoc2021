defmodule AOC2021 do
  import Enum

  def runSubNoAim(cmds) do
    reduce(cmds, {0, 0}, fn
      ({:forward, xn}, {x, y}) -> {x + xn, y}
      ({:down, yn}, {x, y}) -> {x, y + yn}
      ({:up, yn}, {x, y}) -> {x, y - yn}
    end)
  end

  def runSubAim(cmds) do
    reduce(cmds, {0, 0, 0}, fn
      ({:forward, xn}, {x, y, a}) -> {x + xn, y + xn * a, a}
      ({:down, xn}, {x, y, a}) -> {x, y, a + xn}
      ({:up, xn}, {x, y, a}) -> {x, y, a - xn}
    end)
  end

  def day2 do
      cmds = File.read!("day2_input")
      |> String.split("\n", trim: true)
      |> map(&String.split(&1, " ", trim: true, parts: 2))
      |> map(fn [d, f] -> {String.to_atom(d), String.to_integer(f)} end)
    {x, y} = runSubNoAim(cmds)
    IO.inspect(x * y)
    {x, y, _aim} = runSubAim(cmds)
    IO.inspect(x * y)
  end
end

AOC2021.day2()
