defmodule Webcrawler.Models.SiteByMeta do
  @moduledoc """
    Site by meta model
  """

  defstruct [:url, :source_url, :title, :keywords, :description, :last_update]

  @type t :: %{
          url: binary,
          source_url: binary,
          title: binary,
          keywords: binary,
          description: binary,
          last_update: binary | nil
        }

  def new(url, source_url, title \\ "", keywords \\ "", description \\ "", last_update \\ nil) do
    %__MODULE__{
      url: url,
      source_url: source_url,
      title: title,
      keywords: keywords,
      description: description,
      last_update: last_update
    }
  end
end
