defmodule Webcrawler.Models.HtmlMetadata do
  @moduledoc """
    HTML metadata model
  """

  defstruct [:title, :keywords, :description]

  @type t :: %{
          title: binary,
          keywords: binary,
          description: binary
        }

  @spec new(binary, binary, binary) :: t
  def new(title, keywords, description) do
    %__MODULE__{
      title: title,
      keywords: keywords,
      description: description
    }
  end
end
