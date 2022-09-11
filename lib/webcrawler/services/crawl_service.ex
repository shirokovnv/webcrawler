defmodule Webcrawler.Services.CrawlService do
  @moduledoc """
    Crawl service
  """

  alias Webcrawler.JobDispatcher
  alias Webcrawler.Jobs.LinkParse

  def add_link(url) when is_binary(url) do
    JobDispatcher.dispatch(LinkParse.new(url, url, Timex.now()))
  end
end
