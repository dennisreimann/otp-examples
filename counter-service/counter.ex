defmodule Counter do
  @moduledoc """
  Counter service OTP example from the Programming Phoenix book

  Simple process that manages state by running a recursive function.
  As this function is tail-recursive it optimizes to a loop running
  indefinitely.

  ## Examples

      iex> c "counter.ex"
      iex> {:ok, counter} = Counter.start_link(0)
      iex> Counter.inc(counter)
      :inc
      iex> Counter.inc(counter)
      :inc
      iex> Counter.val(counter)
      2
      iex> Counter.dec(counter)
      :inc
      iex> Counter.val(counter)
      1
  """

  @doc """
    Sends an asynchronous increment message to the process.
  """
  def inc(pid), do: send(pid, :inc)

  @doc """
    Sends an asynchronous decrement message to the process.
  """
  def dec(pid), do: send(pid, :dec)

  @doc """
    Sends an asynchronous request for the value to the process.
    It returns the value or exits if the response times out.
  """
  def val(pid, timeout \\ 5000) do
    # Create a reference to receive the asynchronous response
    ref = make_ref()
    send(pid, {:val, self(), ref})
    # Wait for the response and return the value or time out
    receive do
      # Match the exact reference by using `^`. Otherwise `ref`
      # could get reassigned when another response comes in.
      {^ref, val} -> val
    after timeout -> exit(:timeout)
    end
  end

  @doc """
    Starts the process with an initial value.
  """
  def start_link(initial_val) do
    {:ok, spawn_link(fn -> listen(initial_val) end)}
  end

  # Receives the messages and handles them.
  # Manages the value state by calling itself recursively.
  defp listen(val) do
    receive do
      :inc -> listen(val + 1)
      :dec -> listen(val - 1)
      {:val, sender, ref} ->
        send(sender, {ref, val})
        listen(val)
    end
  end
end
