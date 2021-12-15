defmodule AOC2021Test.Macro do
  # mix test --only day:1
  defmacro aoc_test(num, answ) do
    quote do
      @tag day: unquote(num)
      test "day #{unquote(num)}" do
        assert AOC2021.run(unquote(num), true) == unquote(answ)
      end
    end
  end
end
defmodule AOC2021Test do
  use ExUnit.Case
  import AOC2021Test.Macro
  aoc_test(1, {7, 5})
  aoc_test(2, {150, 900})
  aoc_test(3, {198, 230})
  aoc_test(4, {4512, 1924})
  aoc_test(5, {5, 12})
  aoc_test(6, {5934, 26984457539})
  aoc_test(7, {37, 168})
  aoc_test(8, {26}) #, 61229})
  aoc_test(9, {15, 1134})
  #aoc_test(10, {26397})
  #aoc_test(11, {1656})
  #aoc_test(12, {10})
  aoc_test(13, {17, "#####\n#   #\n#   #\n#   #\n#####\n"})
  #aoc_test(14, {1588})
  #aoc_test(15, {40})
end
