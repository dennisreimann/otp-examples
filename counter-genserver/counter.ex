defmodule Counter do
  @moduledoc """
  Counter GenServer example from the Programming Phoenix book

  Encapsulates the counter-service example with GenServer.
  Though the terminology changes, the interface stays the same.
  Compared to the counter-service example the GenServer approach
  simplifies the code by providing hooks for handling the messages.
  It also frees us from using references for the synchronous calls
  as these are set up by GenServer internally.

  ## Examples

      iex> c "counter.ex"
      iex> {:ok, counter} = Counter.start_link(0)
      iex> Counter.inc(counter)
      :ok
      iex> Counter.inc(counter)
      :ok
      iex> Counter.val(counter)
      2
      iex> Counter.dec(counter)
      :ok
      iex> Counter.val(counter)
      1
  """
  use GenServer

  @doc """
    Sends an asynchronous increment message to the server.
  """
  def inc(pid), do: GenServer.cast(pid, :inc)

  @doc """
    Sends an asynchronous decrement message to the server.
  """
  def dec(pid), do: GenServer.cast(pid, :dec)

  @doc """
    Sends a synchronous message to the server requesting the value.
  """
  def val(pid) do
    GenServer.call(pid, :val)
  end

  @doc """
    Starts the process with an initial value.
  """
  def start_link(initial_val) do
    GenServer.start_link(__MODULE__, initial_val)
  end

  @doc """
    GenServer hook that starts the server with an initial value.
  """
  def init(initial_val) do
    {:ok, initial_val}
  end

  @doc """
    GenServer hook that receives the asynchronous message to increment.
  """
  def handle_cast(:inc, val) do
    {:noreply, val + 1}
  end

  @doc """
    GenServer hook that receives the asynchronous message to decrement.
  """
  def handle_cast(:dec, val) do
    {:noreply, val - 1}
  end

  @doc """
    GenServer hook that receives the synchronous request for the value.
  """
  def handle_call(:val, _from, val) do
    {:reply, val, val}
  end
end
