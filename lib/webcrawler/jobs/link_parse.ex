defmodule Webcrawler.Jobs.LinkParse do
  @moduledoc """
    Link parsing job
  """

  defstruct [:url, :source_url, :schedule_at]

  @type t :: %{
          url: binary,
          source_url: binary,
          schedule_at: Timex.Types.valid_datetime()
        }

  @spec new(binary, binary, Timex.Types.valid_datetime()) :: t
  def new(url, source_url, schedule_at) do
    %__MODULE__{
      url: url,
      source_url: source_url,
      schedule_at: schedule_at
    }
  end
end
