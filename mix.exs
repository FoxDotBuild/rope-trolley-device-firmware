defmodule RopeTrolley.MixProject do
  use Mix.Project

  @app :rope_trolley
  @version "0.1.0"
  @all_targets [:rpi3]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.9",
      archives: [nerves_bootstrap: "~> 1.10"],
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {RopeTrolley.Application, []},
      extra_applications: [:logger, :runtime_tools, :pca9685]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.7.0", runtime: false},
      {:shoehorn, "~> 0.7.0"},
      {:ring_logger, "~> 0.8.1"},
      {:toolshed, "~> 0.2.13"},
      {:nerves_ssh, "~> 0.2.1", targets: @all_targets},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.11.3", targets: @all_targets},
      {:nerves_pack, "~> 0.4.0", targets: @all_targets},

      # Dependencies for specific targets
      {:nerves_system_rpi3, "~> 1.13", targets: :rpi3, runtime: false},
      {:circuits_gpio, "~> 0.4.6", targets: @all_targets},
      {:circuits_i2c, "~> 0.3.6", targets: @all_targets},
      {:pca9685, git: "https://github.com/jimsynz/pca9685.ex.git"},
      {:tortoise, git: "https://github.com/lucaong/tortoise"}
    ]
  end

  def release do
    [
      overwrite: true,
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod
    ]
  end
end
