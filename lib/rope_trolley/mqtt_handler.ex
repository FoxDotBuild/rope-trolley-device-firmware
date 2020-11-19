defmodule RopeTrolley.MQTTHandler do
  use Tortoise.Handler
  require Logger

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_args) do
    {:ok, %{}}
  end

  def connection(status, state) do
    IO.puts("?? Connection #{status}...")
    {:ok, state}
  end

  def handle_message(topic, payload, state) do
    IO.puts("UNHANDLED MESSAGE: #{inspect(topic)} - #{inspect(payload)}")
    {:ok, state}
  end

  def subscription(status, topic_filter, state) do
    IO.puts("?? #{inspect(status)} #{inspect(topic_filter)}")
    {:ok, state}
  end

  def terminate(reason, _state) do
    IO.puts("EXIT === #{reason}")
    :ok
  end
end
