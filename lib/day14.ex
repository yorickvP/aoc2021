defmodule AOC2021.Day14 do
  import Enum
  import String, only: [split: 3]
  use Memoize

  defmemo go(_, _, _, 0) do
    %{}
  end

  defmemo go(rules, a, b, depth) do
    rules
    |> find_value(fn
      {^a, ^b, c} -> c
      _ -> nil
    end)
    |> case do
      nil -> go(nil, a, b, 0)
      c -> map_plus(go(rules, a, c, depth - 1), go(rules, c, b, depth - 1)) |> map_plus(%{c => 1})
    end
  end

  def map_plus(a, b) do
    Map.merge(a, b, fn _k, v1, v2 -> v1 + v2 end)
  end

  def run_list(rules, str, depth) do
    str
    |> chunk_every(2, 1, :discard)
    |> map(fn [a, b] -> go(rules, a, b, depth) end)
    |> reduce(frequencies(str), &map_plus/2)
  end

  def input_format do
    :sections
  end

  def run([seed, rules]) do
    seed = seed |> String.split("", trim: true) |> map(&String.to_atom/1)

    rules =
      rules
      |> split("\n", trim: true)
      |> map(&String.split(&1, " -> ", parts: 2))
      |> map(fn [<<a, b>>, <<c>>] ->
        {:erlang.binary_to_atom(<<a>>), :erlang.binary_to_atom(<<b>>),
         :erlang.binary_to_atom(<<c>>)}
      end)

    freqs = run_list(rules, seed, 10)
    min_freq = freqs |> min_by(&elem(&1, 1)) |> elem(1)
    max_freq = freqs |> max_by(&elem(&1, 1)) |> elem(1)
    a = max_freq - min_freq
    freqs = run_list(rules, seed, 40)
    min_freq = freqs |> min_by(&elem(&1, 1)) |> elem(1)
    max_freq = freqs |> max_by(&elem(&1, 1)) |> elem(1)
    b = max_freq - min_freq

    {a, b}
  end
end
