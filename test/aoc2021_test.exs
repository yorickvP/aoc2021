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
  aoc_test(6, {5934, 26_984_457_539})
  aoc_test(7, {37, 168})
  aoc_test(8, {26})
  # , 61229})
  aoc_test(9, {15, 1134})
  aoc_test(10, {26397, 288_957})
  aoc_test(11, {1656, 195})
  aoc_test(12, {10, 36})
  aoc_test(13, {17, "#####\n#   #\n#   #\n#   #\n#####\n"})
  aoc_test(14, {1588, 2_188_189_693_529})
  aoc_test(15, {40, 315})
  aoc_test(16, {31, 54})
  aoc_test(18, {4140, nil})
  @tag day: 16
  test "day 16 / operators" do
    import AOC2021.Day16
    assert to_bits("C200B40A82") |> parse |> elem(0) |> eval == 3
    assert to_bits("04005AC33890") |> parse |> elem(0) |> eval == 54
    assert to_bits("880086C3E88112") |> parse |> elem(0) |> eval == 7
    assert to_bits("CE00C43D881120") |> parse |> elem(0) |> eval == 9
    assert to_bits("D8005AC2A8F0") |> parse |> elem(0) |> eval == 1
    assert to_bits("F600BC2D8F") |> parse |> elem(0) |> eval == 0
    assert to_bits("9C005AC2F8F0") |> parse |> elem(0) |> eval == 0
    assert to_bits("9C0141080250320F1802104A08") |> parse |> elem(0) |> eval == 1
  end

  @tag day: 18
  test "day 18 / explode" do
    import AOC2021.Day18
    assert explode({{{{{9, 8}, 1}, 2}, 3}, 4}) == {{{{0, 9}, 2}, 3}, 4}
    assert explode({7, {6, {5, {4, {3, 2}}}}}) == {7, {6, {5, {7, 0}}}}
    assert explode({{6, {5, {4, {3, 2}}}}, 1}) == {{6, {5, {7, 0}}}, 3}

    assert explode({{3, {2, {1, {7, 3}}}}, {6, {5, {4, {3, 2}}}}}) ==
             {{3, {2, {8, 0}}}, {9, {5, {4, {3, 2}}}}}

    assert explode({{3, {2, {8, 0}}}, {9, {5, {4, {3, 2}}}}}) ==
             {{3, {2, {8, 0}}}, {9, {5, {7, 0}}}}
  end

  @tag day: 18
  test "day 18 / add" do
    import AOC2021.Day18
    assert add([{1, 1}, {2, 2}, {3, 3}, {4, 4}]) == parse_one("[[[[1,1],[2,2]],[3,3]],[4,4]]")
  end
end
