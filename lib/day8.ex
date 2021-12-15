defmodule AOC2021.Day8 do
  import Enum
  import String, only: [split: 1, split: 3]

  def h(x) do
    sort(String.to_charlist(x))
  end

  def deduce(inputs) do
    for i <- inputs |> map(&h/1), into: %{} do
      l = length(i)

      {i,
       cond do
         l == 2 -> 1
         l == 7 -> 8
         l == 4 -> 4
         l == 3 -> 7
         true -> nil
       end}
    end
  end

  def input_format do :lines end
  def run(input) do
    entries =
      input
      |> map(&split(&1, " | ", trim: true))
      |> map(fn [a, b] -> {split(a), split(b)} end)

    count =
      for {inputs, outputs} <- entries, reduce: 0 do
        acc ->
          nums = deduce(inputs)

          outputs
          |> reduce(acc, fn x, acc ->
            if nums[h(x)] != nil do
              acc + 1
            else
              acc
            end
          end)
      end

    {count}
  end
end

