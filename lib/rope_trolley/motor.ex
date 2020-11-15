# Control the 775 motor (single speed currently)
# TODO: Use the PWM controller that the servos use.
defmodule RopeTrolley.Motor do
  @left 22
  @right 23

  # Create a new motor object
  def new() do
    {:ok, left} = Circuits.GPIO.open(@left, :output)
    {:ok, right} = Circuits.GPIO.open(@right, :output)
    %{ left: left, right: right }
  end

  # Stop the motor
  def halt(%{ left: left, right: right }) do
    Circuits.GPIO.write(left, 0)
    Circuits.GPIO.write(right, 0)
  end

  # Move motor counter clockwise
  def ccw(%{ left: left, right: right } = state) do
    halt(state)
    on(left)
    off(right)
  end

  # Move motor clockwise
  def cw(%{ left: left, right: right } = state) do
    halt(state)
    on(right)
    off(left)
  end

  defp on(gpio), do: Circuits.GPIO.write(gpio, 1)
  defp off(gpio), do: Circuits.GPIO.write(gpio, 0)
end
