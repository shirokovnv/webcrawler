defmodule Webcrawler.Models.SiteStatistic do
  @moduledoc """
    Site statistic model
  """

  defstruct [:source_url, :links_count]

  @type t :: %{
          source_url: binary,
          links_count: non_neg_integer
        }

  def new(source_url, links_count \\ 0) do
    %__MODULE__{
      source_url: source_url,
      links_count: links_count
    }
  end
end
