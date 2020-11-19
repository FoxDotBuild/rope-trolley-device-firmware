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

    children =
      [
        %{
          id: Tortoise.Connection,
          start:
            {Tortoise.Connection, :start_link,
             [
               [
                 client_id: "WOW!",
                 server: {Tortoise.Transport.Tcp, host: "test.mosquitto.org", port: 1883},
                 handler: {RopeTrolley.MQTTHandler, []},
                 subscriptions: [{"foo/+/bar", 0}]
               ]
             ]},
          shutdown: 5_000,
          restart: :permanent,
          type: :worker
        }
      ] ++ children(t)

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

  def on_start(:host) do
  end

  def on_start(_) do
    VintageNetWizard.run_wizard()
  end

  def target() do
    Application.get_env(:rope_trolley, :target)
  end
end
