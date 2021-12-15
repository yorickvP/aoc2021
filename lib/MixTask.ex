defmodule Mix.Tasks.Day do
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    {a, b} =
      case args do
        [day] -> AOC2021.run(String.to_integer(day))
        [day, "--test"] -> AOC2021.run(String.to_integer(day), true)
      end

    Mix.shell().info("<= Part 1 =>")
    IO.inspect(a)
    Mix.shell().info("<= Part 2 =>")

    cond do
      is_integer(b) -> IO.inspect(b)
      true -> IO.write(b)
    end
  end
end
