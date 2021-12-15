defmodule AOC2021.Day15 do
  def input_format do
    :lines
  end

  def dijkstra_loop(q, prev, dist, hash, neighbours, length) do
    if PriorityQueue.empty?(q) do
      {dist, prev}
    else
      {{p, u}, q} = PriorityQueue.pop!(q)

      if p == Map.get(dist, hash.(u)) do
        {dist, prev, q} =
          for v <- neighbours.(u), reduce: {dist, prev, q} do
            {dist, prev, q} ->
              alt = (dist |> Map.get(hash.(u), {:infinity})) + length.(u, v)

              if alt < dist |> Map.get(hash.(v), {:infinity}) do
                {Map.put(dist, hash.(v), alt), Map.put(prev, hash.(v), u),
                 q |> PriorityQueue.put(alt, v)}
              else
                {dist, prev, q}
              end
          end

        dijkstra_loop(q, prev, dist, hash, neighbours, length)
      else
        dijkstra_loop(q, prev, dist, hash, neighbours, length)
      end
    end
  end

  def dijkstra(source, hash, neighbours, length) do
    q = PriorityQueue.new() |> PriorityQueue.put(0, source)

    dist = %{hash.(source) => 0}
    prev = %{}
    dijkstra_loop(q, prev, dist, hash, neighbours, length)
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

    {dist, _prev} =
      dijkstra(
        field,
        &Field.pos/1,
        fn field ->
          [
            field |> Field.left(),
            field |> Field.up(),
            field |> Field.down(),
            field |> Field.right()
          ]
          |> reject(&(is_nil(&1) || is_nil(&1.n)))
        end,
        fn _, v -> v.n.n end
      )

    {dist[{tx - 1, ty - 1}], 0}
  end
end
