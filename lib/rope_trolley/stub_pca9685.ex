defmodule RopeTrolley.StubPCA9685 do
  @moduledoc """
  Stub controller for doing development in Host mode
  """

  def channel(_bus, _address, channel, _unknown, freq) do
    IO.puts("Channel #{inspect(channel)} set to #{inspect(freq)}")
  end
end
