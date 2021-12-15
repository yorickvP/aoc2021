defmodule AOC2021.Day2 do
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

  def input_format do :lines end
  def run(input) do
    cmds = for line <- input do
      [d, f] = String.split(line, " ", trim: true, parts: 2)
      {String.to_atom(d), String.to_integer(f)}
    end
    {x, y} = runSubNoAim(cmds)
    a = x * y
    {x, y, _aim} = runSubAim(cmds)
    b = x * y
    {a, b}
  end
end
