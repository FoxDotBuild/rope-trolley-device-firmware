# Responsible for integration of MQTT signals + Physical motors
defmodule RopeTrolley.MotorController do
  require Logger
  alias RopeTrolley.Motor

  @motor RopeTrolley.Motor.new()

  def perform_movement(cmd)
      when is_binary(cmd),
      do: perform_movement(Integer.parse(cmd))

  # Move CCW
  def perform_movement({cmd, ""})
      when is_integer(cmd) and
             cmd < -5,
      do: Motor.ccw(@motor, cmd)

  # Move CW
  def perform_movement({cmd, ""})
      when is_integer(cmd) and
             cmd > 5,
      do: Motor.cw(@motor, cmd)

  # Pull the brakes
  def perform_movement(cmd)
      when is_integer(cmd),
      do: Motor.brake(@motor)

  def perform_movement(cmd) do
    Logger.error("Don't know how to handle value #{inspect(cmd)}")
  end
end
