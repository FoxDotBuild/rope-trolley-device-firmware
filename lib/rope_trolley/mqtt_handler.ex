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
    Logger.info("MQTT Status: #{inspect(status)}")
    {:ok, state}
  end

  def handle_message(["rope_trolley", speed], payload, state) do
    Logger.info("Got message: #{inspect(speed)} / #{inspect(payload)}")
    RopeTrolley.MotorController.perform_movement(payload)
    {:ok, state}
  end

  def handle_message(topic, _payload, state) do
    Logger.info("Getting unknown message on #{inspect(topic)}")
    {:ok, state}
  end

  def subscription(status, topic_filter, state) do
    Logger.debug("#{inspect(topic_filter)} => #{inspect(status)}")
    {:ok, state}
  end

  def terminate(_reason, _state) do
    :ok
  end
end
