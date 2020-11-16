defmodule RopeTrolley.OldMotor do
  @moduledoc """
  A deprecated motor control module that does not do speed
  control.
  """
  # Arbitrary RPi GPIO pins:
  @left 22
  @right 23
  @gpio Circuits.GPIO

  # Create a new motor object
  def new() do
    {:ok, left} = @gpio.open(@left, :output)
    {:ok, right} = @gpio.open(@right, :output)
    %{left: left, right: right}
  end

  @deprecated "Use RopeTrolley.Motor instead"
  def halt(%{left: left, right: right}) do
    @gpio.write(left, 0)
    @gpio.write(right, 0)
  end

  @deprecated "Use RopeTrolley.Motor instead"
  def ccw(%{left: left, right: right} = state) do
    halt(state)
    on(left)
    off(right)
  end

  @deprecated "Use RopeTrolley.Motor instead"
  def cw(%{left: left, right: right} = state) do
    halt(state)
    on(right)
    off(left)
  end

  defp on(gpio), do: @gpio.write(gpio, 1)
  defp off(gpio), do: @gpio.write(gpio, 0)
end
