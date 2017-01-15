defmodule Untimely.Server do
  use GenServer

  @name __MODULE__

  def start_link, do: GenServer.start_link(__MODULE__, [], name: @name)

  def start_task, do: GenServer.cast(@name, :start)

  def wait_for_task, do: GenServer.cast(@name, {:wait, self()})

  def init([]) do
    {:ok, %{count: 0, waiting: []}}
  end

  def handle_cast(:start, %{count: n} = state) do
    {:noreply, notify_started(%{state | count: n + 1})}
  end

  def handle_cast({:wait, pid}, %{waiting: pids} = state) do
    {:noreply, notify_started(%{state | waiting: [pid | pids]})}
  end

  defp notify_started(%{count: 0} = state), do: state
  defp notify_started(%{count: _, waiting: pids} = state) do
    :lists.foreach(fn pid -> Process.send(pid, :started, []) end, pids)
    %{state | waiting: []}
  end

end
