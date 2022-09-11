defmodule Webcrawler.Models.Site do
  @moduledoc """
    Site model
  """

  defstruct [:url, :source_url, :html, :last_update]

  @type t :: %{
          url: binary,
          source_url: binary,
          html: binary,
          last_update: Timex.Types.valid_datetime() | nil
        }

  def new(url, source_url, html, last_update \\ nil) do
    %__MODULE__{
      url: url,
      source_url: source_url,
      html: html,
      last_update: last_update
    }
  end
end
