defmodule AOC2021.Day12 do
  def input_format do
    :lines
  end

  import Enum
  import String, only: [split: 3]

  def is_lowercase(s) do
    String.downcase(s) == s
  end

  def count_paths({:end, true}, _prev, _, _) do
    1
  end

  def count_paths({n, small}, prev, adj, limit) do
    prev =
      if small do
        Map.update(prev, n, 1, &(&1 + 1))
      else
        prev
      end

    for {neigh, nsmall} <- Map.get(adj, {n, small}, []), reduce: 0 do
      acc ->
        visited_before = Map.has_key?(prev, neigh)

        acc +
          if (nsmall && Map.get(prev, neigh, 0) >= limit) || neigh == :start do
            0
          else
            count_paths(
              {neigh, nsmall},
              prev,
              adj,
              if visited_before do
                limit - 1
              else
                limit
              end
            )
          end
    end
  end

  def run(input) do
    entries =
      input
      |> map(&split(&1, "-", parts: 2))
      |> map(&map(&1, fn x -> {String.to_atom(x), is_lowercase(x)} end))
      |> map(fn [a, b] -> {a, b} end)

    adj =
      for {a, b} <- entries, reduce: %{} do
        m ->
          m
          |> Map.update(a, [b], &[b | &1])
          |> Map.update(b, [a], &[a | &1])
      end

    a = count_paths({:start, true}, Map.new(), adj, 1)
    b = count_paths({:start, true}, Map.new(), adj, 2)
    {a, b}
  end
end
