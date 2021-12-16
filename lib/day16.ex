defmodule AOC2021.Day16 do
  def input_format do
    nil
  end

  import Enum

  def to_bits(<<>>) do
    <<>>
  end

  def to_bits(<<n, rest::binary>>) do
    <<String.to_integer(<<n>>, 16)::4, to_bits(rest)::bitstring>>
  end

  def parse_literal(n, <<follows::1, t::4, rest::bitstring>>) do
    n = n * 16 + t

    if follows == 1 do
      parse_literal(n, rest)
    else
      {n, rest}
    end
  end

  @literal 4
  def operator_decode(t) do
    case t do
      0 -> :sum
      1 -> :product
      2 -> :minimum
      3 -> :maximum
      5 -> :gt
      6 -> :lt
      7 -> :eq
    end
  end

  def parse(<<v::3, @literal::3, contents::bitstring>>) do
    {n, rest} = parse_literal(0, contents)
    {{v, :literal, n}, rest}
  end

  # operator, length type 0
  def parse(<<v::3, t::3, 0::1, l::15, sub::bitstring-size(l), rest::bitstring>>) do
    {{v, :operator, operator_decode(t), parse_all(sub)}, rest}
  end

  # operator, length type 1
  def parse(<<v::3, t::3, 1::1, l::11, rest::bitstring>>) do
    {n, rest} = parse_multiple(rest, l)
    {{v, :operator, operator_decode(t), n}, rest}
  end

  def parse_multiple(str, 0) do
    {[], str}
  end

  def parse_multiple(str, n) do
    {p, rest} = parse(str)
    {tail, rest} = parse_multiple(rest, n - 1)
    {[p | tail], rest}
  end

  def parse_all(<<>>) do
    []
  end

  def parse_all(str) do
    case parse(str) do
      {p, rest} -> [p | parse_all(rest)]
    end
  end

  def version_sum({v, :literal, _}) do
    v
  end

  def version_sum({v, :operator, _, contents}) do
    v + (contents |> map(&version_sum/1) |> sum)
  end

  def eval({_, :literal, n}) do
    n
  end

  def eval({_, :operator, op, f}) do
    case {op, map(f, &eval/1)} do
      {:sum, x} ->
        sum(x)

      {:product, x} ->
        product(x)

      {:minimum, x} ->
        min(x)

      {:maximum, x} ->
        max(x)

      {:gt, [a, b]} ->
        if a > b do
          1
        else
          0
        end

      {:lt, [a, b]} ->
        if a < b do
          1
        else
          0
        end

      {:eq, [a, b]} ->
        if a == b do
          1
        else
          0
        end
    end
  end

  def run(input) do
    entries = input |> String.trim() |> to_bits
    {n, _} = parse(entries)
    a = version_sum(n)
    b = eval(n)
    {a, b}
  end
end
