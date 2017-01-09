defmodule Counter do
  @moduledoc """
  Counter Agent example from the Programming Phoenix book

  Simplifies the counter-genserver example with an Agent.
  Again the terminology changes slightly, but the interface
  stays the same.
  Compared to the counter-genserver example the Agent approach
  simplifies the code even further by abstracting the GenServer.

  ## Examples

      iex> c "counter.ex"
      iex> {:ok, agent} = Counter.start_link(0)
      iex> Counter.inc(agent)
      :ok
      iex> Counter.inc(agent)
      :ok
      iex> Counter.val(agent)
      2
      iex> Counter.dec(agent)
      :ok
      iex> Counter.val(agent)
      1
  """

  @doc """
    Sends an increment message to the agent.
  """
  def inc(agent), do: Agent.update(agent, &(&1 + 1))

  @doc """
    Sends a decrement message to the agent.
  """
  def dec(agent), do: Agent.update(agent, &(&1 - 1))

  @doc """
    Sends a message to the agent requesting the value.
  """
  def val(agent), do: Agent.get(agent, &(&1))

  @doc """
    Starts the agent with an initial value.
  """
  def start_link(initial_val) do
    Agent.start_link fn -> initial_val end
  end
end
