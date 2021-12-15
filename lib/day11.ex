defmodule AOC2021.Day11 do
  defmodule FlashCounter do
    use GenServer
    @impl true
    def init(nil) do
      {:ok, 0}
    end

    @impl true
    def handle_cast(:flash, cnt) do
      {:noreply, cnt + 1}
    end

    @impl true
    def handle_call(:get, _from, cnt) do
      {:reply, cnt, cnt}
    end
  end

  defmodule Octopus do
    use GenServer
    @impl true
    def init(level) do
      {:ok, {level, false, [], false}}
    end

    @impl true
    def handle_cast({:neighs, neighs}, {level, flashed, _neighs, false}) do
      {:noreply, {level, flashed, neighs, false}}
    end

    @impl true
    def handle_cast(:maybe_flash, {level, false, neighs, true}) do
      if level > 9 do
        neighs |> Enum.each(&GenServer.cast(&1, :expose))
        {:noreply, {level, true, neighs, true}}
      else
        {:noreply, {level, false, neighs, true}}
      end
    end

    @impl true
    def handle_cast(:maybe_flash, {level, true, neighs, true}) do
      # assert level over 9
      {:noreply, {level, true, neighs, true}}
    end

    @impl true
    def handle_cast(:expose, {level, true, neighs, true}) do
      {:noreply, {level, true, neighs, true}}
    end

    @impl true
    def handle_cast(:expose, {level, false, neighs, true}) do
      level = level + 1

      if level > 9 do
        neighs |> Enum.each(&GenServer.cast(&1, :expose))
        {:noreply, {level, true, neighs, true}}
      else
        {:noreply, {level, false, neighs, true}}
      end
    end

    @impl true
    def handle_call(:time, _, {level, _flashed, neighs, false}) do
      {:reply, :ok, {level + 1, false, neighs, true}}
    end

    @impl true
    def handle_call(:end, _, {level, flashed, neighs, true}) do
      if flashed do
        GenServer.cast(:cnt, :flash)
      end

      {:reply, :ok,
       {if flashed do
          0
        else
          level
        end, false, neighs, false}}
    end

    @impl true
    def handle_call(:get, _from, {level, flashed, neighs, false}) do
      {:reply, level, {level, flashed, neighs, false}}
    end
  end

  def input_format do
    :lines
  end

  import Enum
  import String, only: [split: 3]
  alias AOC2021.Day9.Field, as: Field
  alias AOC2021.Day9.Zipper, as: Zipper

  def step(field) do
    {_, all_nodes} =
      Field.reduce(field, [], fn field, acc ->
        {field, [field.n.n | acc]}
      end)

    all_nodes |> each(&GenServer.call(&1, :time))
    all_nodes |> each(&GenServer.cast(&1, :maybe_flash))
    :timer.sleep(1)
    field |> Field.each(&GenServer.call(&1, :end))
  end

  def step_until_all(field, count, n \\ 0) do
    before = GenServer.call(:cnt, :get)
    step(field)
    afterw = GenServer.call(:cnt, :get)

    if afterw - before == count do
      n + 1
    else
      step_until_all(field, count, n + 1)
    end
  end

  def run(input) do
    entries =
      input
      |> map(fn x -> split(x, "", trim: true) |> AOC2021.ints() end)

    {:ok, flash_counter} = GenServer.start_link(FlashCounter, nil)
    Process.register(flash_counter, :cnt)

    field = Field.make(entries)
    octopus_count = (Zipper.to_list(field) |> length) * (Zipper.to_list(field.n) |> length)

    field =
      field
      |> Field.map(fn c ->
        {:ok, pid} = GenServer.start_link(Octopus, c)
        pid
      end)

    field
    |> Field.reduce(nil, fn cell, _ ->
      # tell octopuses about their neighbours
      neighs = Field.neighbours(cell, true) |> map(&Field.get_or_nil/1)
      {cell, GenServer.cast(cell.n.n, {:neighs, neighs})}
    end)

    for _ <- 1..100 do
      step(field)
    end

    a = GenServer.call(flash_counter, :get)
    b = step_until_all(field, octopus_count, 100)
    # field_str = field |> Field.map(&GenServer.call(&1, :get))
    # IO.write(Field.to_string(field_str) <> "\n")
    {a, b}
  end
end
