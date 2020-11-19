defmodule RopeTrolley.StubWifi do
  def stub?() do
    true
  end

  def run_wizard() do
    IO.puts("Stub WiFi activated")
  end
end
