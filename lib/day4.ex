defmodule AOC2021.Day4 do
  import Enum
  import String, only: [split: 3, to_integer: 1]

  def is_mark(n) do
    n == :mark
  end

  def mark(board, num) do
    for l <- board do
      for n <- l do
        if n == num do
          :mark
        else
          n
        end
      end
    end
  end

  def winning(board) do
    rows = any?(for l <- board, do: all?(l, &is_mark/1))
    cols = any?(for r <- zip_with(board, & &1), do: all?(r, &is_mark/1))
    rows || cols
  end

  def score(board, num) do
    num *
      sum(for l <- board, do: l |> reject(&is_mark/1) |> sum)
  end

  def board_winning(board, [num | rest], turn \\ 0) do
    board = mark(board, num)

    if winning(board) do
      {turn, score(board, num)}
    else
      board_winning(board, rest, turn + 1)
    end
  end

  def input_format do
    :sections
  end

  def run([numbers | boards]) do
    numbers = numbers |> split(",", trim: true) |> map(&to_integer/1)

    boards =
      for b <- boards do
        lines = split(b, "\n", trim: true)
        for f <- lines, do: String.split(f) |> map(&to_integer/1)
      end

    {_turn, score_a} = boards |> map(&board_winning(&1, numbers)) |> min_by(&elem(&1, 0))
    {_turn, score_b} = boards |> map(&board_winning(&1, numbers)) |> max_by(&elem(&1, 0))
    {score_a, score_b}
  end
end
