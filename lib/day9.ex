defmodule AOC2021.Day9 do
  defmodule Zipper do
    defstruct [:left, :n, :right, :pos]

    def make([h | t]) do
      %Zipper{left: [], n: h, right: t, pos: 0}
    end

    def set(z, n) do
      %Zipper{left: z.left, n: n, right: z.right, pos: z.pos}
    end

    def dec(%Zipper{left: [h | t], n: n, right: r, pos: p}) do
      %Zipper{left: t, n: h, right: [n | r], pos: p - 1}
    end

    def dec(_) do
      nil
    end

    def inc(%Zipper{left: l, n: n, right: [h | t], pos: p}) do
      %Zipper{left: [n | l], n: h, right: t, pos: p + 1}
    end

    def inc(_) do
      nil
    end

    def map(z, f) do
      %Zipper{left: Enum.map(z.left, f), n: f.(z.n), right: Enum.map(z.right, f), pos: z.pos}
    end

    def to_list(%Zipper{left: [], n: n, right: r}) do
      [n | r]
    end

    def to_list(nil) do
      raise "to_list(nil)"
    end

    def to_list(other) do
      to_list(dec(other))
    end

    def repeat(z, count, mapper) do
      # todo: loses position
      list = to_list(z)

      Stream.unfold(count, fn
        0 -> nil
        # todo: plus?
        n -> {Enum.map(list, &mapper.(&1, count - n)), n - 1}
      end)
      |> Stream.concat()
      |> Enum.to_list()
      |> Zipper.make()
    end

    def to_string(z, str \\ &Integer.to_string/1, join \\ "") do
      to_list(z) |> Enum.map(str) |> Enum.join(join)
    end
  end

  defmodule Field do
    import Zipper

    def make(arr) do
      Zipper.make(arr |> Enum.map(&Zipper.make/1))
    end

    def left(z) do
      Zipper.map(z, &dec/1)
    end

    def right(z) do
      Zipper.map(z, &inc/1)
    end

    def pos(z) do
      {z.pos, z.n.pos}
    end

    def up(z) do
      dec(z)
    end

    def down(z) do
      inc(z)
    end

    def get_or_nil(nil) do
      nil
    end

    def get_or_nil(%Zipper{n: %Zipper{n: n}}) do
      n
    end

    def get_or_nil(%Zipper{n: nil}) do
      nil
    end

    def neighbours(field) do
      [
        field |> Field.left(),
        field |> Field.up(),
        field |> Field.down(),
        field |> Field.right()
      ]
      |> Enum.reject(&(is_nil(&1) || is_nil(&1.n)))
    end

    def set(z, n) do
      Zipper.set(z, Zipper.set(z.n, n))
    end

    def reduce(field, acc, f) do
      {field, acc} = f.(field, acc)
      l = field |> left |> get_or_nil
      r = field |> right |> get_or_nil
      t = field |> up |> get_or_nil
      b = field |> down |> get_or_nil
      v = field |> get_or_nil

      case {l, r, t, b, v} do
        # leftmost, no down
        {nil, _, _, nil, _} ->
          {field, acc} = reduce(field |> right, acc, f)
          {field |> left, acc}

        # leftmost, has down
        {nil, _, _, _, _} ->
          {field, acc} = reduce(field |> right, acc, f)
          {field, acc} = reduce(field |> left |> down, acc, f)
          {field |> up, acc}

        # rightmost
        {_, nil, _, _, _} ->
          {field, acc}

        # middle cell
        {_, _, _, _, _} ->
          {field, acc} = reduce(field |> right, acc, f)
          {field |> left, acc}
      end
    end

    def repeat(z, n, mapper) do
      Zipper.repeat(Zipper.map(z, &Zipper.repeat(&1, n, mapper)), n, fn z, i ->
        Zipper.map(z, &mapper.(&1, i))
      end)
    end

    def to_string(z) do
      to_list(z) |> Enum.map(&Zipper.to_string/1) |> Enum.join("\n")
    end
  end

  import Enum
  import String, only: [split: 3]

  def lt(m, nb) do
    all?(nb, &(m < &1))
  end

  def low_val(field, acc) do
    import Field
    l = field |> left |> get_or_nil
    r = field |> right |> get_or_nil
    t = field |> up |> get_or_nil
    b = field |> down |> get_or_nil
    v = field |> get_or_nil
    lower = lt(v, [l, r, t, b] |> reject(&is_nil/1))

    {field,
     acc +
       if lower do
         1 + v
       else
         0
       end}
  end

  def count_lows(field) do
    {_, acc} = Field.reduce(field, 0, &low_val/2)
    acc
  end

  def flood_fill(field, acc) do
    import Field

    if get_or_nil(field) == 9 || is_nil(get_or_nil(field)) do
      nil
    else
      field = set(field, 9)
      acc = acc + 1

      {acc, field} =
        with {acc, nfield} <- flood_fill(field |> down, acc) do
          {acc, nfield |> up}
        else
          _ -> {acc, field}
        end

      {acc, field} =
        with {acc, nfield} <- flood_fill(field |> up, acc) do
          {acc, nfield |> down}
        else
          _ -> {acc, field}
        end

      {acc, field} =
        with {acc, nfield} <- flood_fill(field |> left, acc) do
          {acc, nfield |> right}
        else
          _ -> {acc, field}
        end

      {acc, field} =
        with {acc, nfield} <- flood_fill(field |> right, acc) do
          {acc, nfield |> left}
        else
          _ -> {acc, field}
        end

      {acc, field}
    end
  end

  def get_basins(field) do
    {field, acc} =
      Field.reduce(field, [], fn field, acc ->
        with {size, nfield} <- flood_fill(field, 0) do
          {nfield, [size | acc]}
        else
          nil -> {field, acc}
        end
      end)

    {field, acc}
  end

  def input_format do
    :lines
  end

  def run(input) do
    entries =
      input
      |> map(fn x -> split(x, "", trim: true) |> AOC2021.ints() end)

    field = Field.make(entries)
    a = count_lows(field)

    # todo: assert all 9's
    {_, acc} = get_basins(field)
    b = acc |> sort(:desc) |> take(3) |> product
    {a, b}
  end
end
