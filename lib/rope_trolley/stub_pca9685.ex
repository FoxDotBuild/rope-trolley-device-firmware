defmodule RopeTrolley.StubPCA9685 do
  @moduledoc """
  Stub controller for doing development in Host mode
  """

  def channel(_bus, _address, _channel, _unknown, _freq) do
    Process.sleep(100)
  end
end
