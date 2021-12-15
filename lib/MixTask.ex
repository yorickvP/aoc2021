defmodule Mix.Tasks.Day do

  use Mix.Task

  @impl Mix.Task
  def run([day]) do
    {a, b} = AOC2021.run(String.to_integer(day))
    Mix.shell().info("<= Part 1 =>")
    IO.inspect(a)
    Mix.shell().info("<= Part 2 =>")
    cond do
      is_integer(b) -> IO.inspect(b)
      true -> IO.write(b)
    end
  end
end
