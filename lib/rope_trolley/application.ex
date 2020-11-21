defmodule RopeTrolley.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RopeTrolley.Supervisor]
    t = target()

    children = [mqtt_config()] ++ children(t)

    on_start(t)
    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    []
  end

  def children(:rpi3) do
    []
  end

  def on_start(_target) do
    Application.fetch_env!(:rope_trolley, :wifi_wizard).run_wizard()
  end

  def target() do
    Application.get_env(:rope_trolley, :target)
  end

  def mqtt_config do
    %{
      id: Tortoise.Connection,
      start:
        {Tortoise.Connection, :start_link,
         [
           [
             client_id: "rope_trolley_device_#{:random.uniform(100_000)}",
             server: {Tortoise.Transport.Tcp, host: "localhost", port: 1883},
             handler: {RopeTrolley.MQTTHandler, []},
             subscriptions: [{"rope_trolley/+", 0}]
           ]
         ]},
      shutdown: 5_000,
      restart: :permanent,
      type: :worker
    }
  end
end
