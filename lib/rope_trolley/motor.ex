defmodule RopeTrolley.Motor do
  @moduledoc """
  Code to control 775 motor spindle.
  How it is is physically built:

  775 Motor =>
    L298N motor controller =>
      PCA9685 PWM controller
  """

  defstruct channel_a: 8, channel_b: 7

  @min_speed 1325
  @max_speed 4095
  @i_have_no_idea 0
  @device Application.fetch_env!(:rope_trolley, :pca9685_device)
  @channel_a 8
  @channel_b 9
  @bus "i2c-1"
  @address 0x40

  require Logger

  @doc "Creates a new motor object."
  def new(chan_a \\ @channel_a, chan_b \\ @channel_b) do
    %__MODULE__{channel_a: chan_a, channel_b: chan_b}
  end

  @doc "Move the motor counter-clockwise at a given speed."
  def ccw(motor, percentage) do
    Logger.debug("CCW @ #{percentage}%")
    brake(motor)
    pwm(motor.channel_a, to_freq(percentage))
  end

  @doc "Move the motor clockwise at a given speed."
  def cw(motor, percentage) do
    Logger.debug("CW @ #{percentage}%")
    brake(motor)
    pwm(motor.channel_b, to_freq(percentage))
  end

  def brake(motor) do
    Logger.debug("Apply brakes")
    pwm(motor.channel_a, 0)
    pwm(motor.channel_b, 0)
  end

  defp to_freq(pct) do
    float = pct / 100
    range = @max_speed - @min_speed
    scaled_max = float * range
    Kernel.trunc(@min_speed + scaled_max)
  end

  defp pwm(chan, freq) do
    @device.channel(@bus, @address, chan, @i_have_no_idea, freq)
  end
end
