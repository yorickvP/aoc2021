defmodule Mix.Tasks.Day do
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    {tc, {a, b}} =
      case args do
        [day] -> :timer.tc(fn -> AOC2021.run(String.to_integer(day)) end)
        [day, "--test"] -> :timer.tc(fn -> AOC2021.run(String.to_integer(day), true) end)
      end

    Mix.shell().info("took #{tc / 1_000_000} seconds")

    Mix.shell().info("<= Part 1 =>")
    IO.inspect(a)
    Mix.shell().info("<= Part 2 =>")

    cond do
      is_integer(b) -> IO.inspect(b)
      true -> IO.write(b)
    end
  end
end
