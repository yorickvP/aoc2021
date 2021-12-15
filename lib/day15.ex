defmodule AOC2021.Day15 do
  def input_format do
    :lines
  end

  def dijkstra_loop(q, prev, dist, hash, neighbours, length, target) do
    if PriorityQueue.empty?(q) do
      {dist, prev}
    else
      {{p, u}, q} = PriorityQueue.pop!(q)

      cond do
        target != nil && hash.(u) == target ->
          {dist, prev}

        p == Map.get(dist, hash.(u)) ->
          {dist, prev, q} =
            for v <- neighbours.(u), reduce: {dist, prev, q} do
              {dist, prev, q} ->
                alt = (dist |> Map.get(hash.(u), {:infinity})) + length.(u, v)

                if alt < dist |> Map.get(hash.(v), {:infinity}) do
                  # Map.put(prev, hash.(v), u),
                  {Map.put(dist, hash.(v), alt), prev, q |> PriorityQueue.put(alt, v)}
                else
                  {dist, prev, q}
                end
            end

          dijkstra_loop(q, prev, dist, hash, neighbours, length, target)

        true ->
          dijkstra_loop(q, prev, dist, hash, neighbours, length, target)
      end
    end
  end

  def dijkstra(source, hash, neighbours, length, target \\ nil) do
    q = PriorityQueue.new() |> PriorityQueue.put(0, source)

    dist = %{hash.(source) => 0}
    prev = %{}
    dijkstra_loop(q, prev, dist, hash, neighbours, length, target)
  end

  import Enum
  import String, only: [split: 3]
  alias AOC2021.Day9.Field, as: Field

  def run(input) do
    entries =
      input
      |> map(fn x -> split(x, "", trim: true) |> AOC2021.ints() end)

    field = Field.make(entries)
    {tx, ty} = {length(entries), length(List.first(entries))}
    target = {tx - 1, ty - 1}

    {dist, _prev} =
      dijkstra(field, &Field.pos/1, &Field.neighbours/1, fn _, v -> v.n.n end, target)

    a = dist[target]

    bigger_field = field |> Field.repeat(5, fn x, i -> rem(x + i - 1, 9) + 1 end)
    bigger_target = {tx * 5 - 1, ty * 5 - 1}

    {dist, _prev} =
      dijkstra(
        bigger_field,
        &Field.pos/1,
        &Field.neighbours/1,
        fn _, v -> v.n.n end,
        bigger_target
      )

    b = dist[bigger_target]

    {a, b}
  end
end
