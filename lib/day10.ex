defmodule AOC2021.Day10 do
  def match(<<>>, []) do
    :ok
  end
  def match(str, stack) do
    case str do
      <<?{, rest::binary>> -> match(rest, [?} | stack])
      <<?(, rest::binary>> -> match(rest, [?) | stack])
      <<?[, rest::binary>> -> match(rest, [?] | stack])
      <<?<, rest::binary>> -> match(rest, [?> | stack])
      
      <<n, rest::binary>> ->
        with [^n | rstack] <- stack do
          match(rest, rstack)
        else
          _ -> {:invalid, score(n)}
        end
      <<>> -> {:eol, completion_score(stack)}
    end
  end
  import Enum
  def median(list) do
    i = div((list |> length) - 1, 2)
    list |> sort |> at(i)
  end
  def input_format do :lines end
  def run(input) do
    scores = input |> map(&match(&1, []))
    a = for {:invalid, n} <- scores do n end |> sum
    b = for {:eol, n} <- scores do n end |> median
    {a, b}
  end
  def completion_score(stack) do
    stack |> reduce(0, fn
      ?), acc -> 5 * acc + 1
      ?], acc -> 5 * acc + 2
      ?}, acc -> 5 * acc + 3
      ?>, acc -> 5 * acc + 4
        end)
  end
  def score(n) do
    case n do
      ?) -> 3
      ?] -> 57
      ?} -> 1197
      ?> -> 25137
    end
  end
end
