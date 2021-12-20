defmodule AOC2021.Day18 do
  import Enum

  def input_format do
    :lines
  end

  def parse(<<?[, contents::binary>>) do
    {a, <<_, contents::binary>>} = parse(contents)
    {b, <<_, contents::binary>>} = parse(contents)
    {{a, b}, contents}
  end

  def parse(literal) do
    case literal |> String.split([",", "]"], parts: 2) do
      [l, rest] -> {String.to_integer(l), <<?_, rest::binary>>}
      [l] -> {String.to_integer(l), ""}
    end
  end

  def count_lits({a, b}) do
    count_lits(a) + count_lits(b)
  end

  def count_lits(_) do
    1
  end

  def update_nth({a, b}, n, f) do
    {update_nth(a, n, f), update_nth(b, n - count_lits(a), f)}
  end

  def update_nth(x, 0, f) do
    f.(x)
  end

  def update_nth(x, _, _) do
    x
  end

  def explode(x) do
    with {nil, ^x} <- explode(x, 0, 0) do
      x
    else
      {:ex, {n, a, b}, r} ->
        r
        |> update_nth(n - 1, &(&1 + a))
        |> update_nth(n + 1, &(&1 + b))
    end
  end

  def explode({a, b}, n, 4) do
    {:ex, {n, a, b}, 0}
  end

  def explode({a, b}, n, depth) do
    with {nil, ^a} <- explode(a, n, depth + 1) do
      with {nil, ^b} <- explode(b, n + count_lits(a), depth + 1) do
        {nil, {a, b}}
      else
        {:ex, exp, x} -> {:ex, exp, {a, x}}
      end
    else
      {:ex, exp, x} -> {:ex, exp, {x, b}}
    end
  end

  def explode(x, _, _) do
    {nil, x}
  end

  def split({a, b}) do
    with ^a <- split(a) do
      {a, split(b)}
    else
      a -> {a, b}
    end
  end

  def split(x) do
    if x > 9 do
      {div(x, 2), div(x + 1, 2)}
    else
      x
    end
  end

  def reduce(x) do
    with ^x <- explode(x),
         ^x <- split(x) do
      x
    else
      x -> reduce(x)
    end
  end

  def magnitude({x, y}) do
    3 * magnitude(x) + 2 * magnitude(y)
  end

  def magnitude(x) do
    x
  end

  def add(a, b) do
    reduce({a, b})
  end

  def add(x) do
    x |> reduce(&add(&2, &1))
  end

  def parse_one(x) do
    {x, ""} = parse(x)
    x
  end

  def run(input) do
    entries = input |> map(&parse_one/1)
    a = magnitude(add(entries))

    b =
      for a <- entries, reduce: 0 do
        m ->
          for b <- entries, reduce: m do
            m ->
              if a != b do
                Kernel.max(m, magnitude(add(a, b)))
              else
                m
              end
          end
      end

    {a, b}
  end
end
