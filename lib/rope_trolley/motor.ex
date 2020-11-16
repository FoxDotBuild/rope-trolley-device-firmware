defmodule RopeTrolley.Motor do
  @moduledoc """
  Code to control 775 motor spindle.
  How it is is physically built:

  775 Motor =>
    L298N motor controller =>
      PCA9685 PWM controller
  """

  defstruct channel_a: 8, channel_b: 7

  @min_sped 1325
  @max_sped 4095
  @i_have_no_idea 0
  @device PCA9685.Device
  @channel 8
  @bus "i2c-1"
  @address 0x40

  @doc "Creates a new motor object."
  def new(chan_a \\ 8, chan_b \\ 9) do
    %__MODULE__{channel_a: chan_a, channel_b: chan_b}
  end

  @doc "Move the motor counter-clockwise at a given speed."
  def ccw(motor, speed_percentage) do
    off(motor)
    pwm(motor.channel_a, to_freq(speed_percentage))
  end

  @doc "Move the motor clockwise at a given speed."
  def cw(motor, speed_percentage) do
    off(motor)
    pwm(motor.channel_b, to_freq(speed_percentage))
  end

  defp to_freq(pct) do
    float = pct / 100
    range = @min_sped - @max_sped
    scaled_max = float * range
    @min_speed + scaled_max
  end

  defp off(motor) do
    pwm(motor.channel_a, 0)
    pwm(motor.channel_b, 0)
  end

  defp pwm(chan, freq) do
    @device.channel(@bus, @address, chan, @i_have_no_idea, freq)
  end
end
