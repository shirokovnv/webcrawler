defmodule Webcrawler.Workers.LinkParser do
  @moduledoc """
    Link parsing worker
  """

  alias Webcrawler.JobDispatcher
  alias Webcrawler.Jobs.LinkParse
  alias Webcrawler.Services.{HtmlService, HttpParser, UrlService}
  alias Webcrawler.Repo.{Sites, SitesByMeta, SiteStatistics}
  alias Webcrawler.Models.{Site, SiteByMeta, SiteStatistic}

  @delay_interval 10..20

  def perform(url, source_url) do
    {:ok, url} = UrlService.normalize(url, source_url)

    if !Sites.exists?(url) do
      case HttpParser.parse_http_response(url) do
        {:ok, html} ->
          {:ok, links} = HtmlService.parse_links(html, source_url)
          {:ok, meta} = HtmlService.parse_meta(html)

          last_update = Timex.now()
          Sites.create(Site.new(url, source_url, html, last_update))

          SitesByMeta.create(
            SiteByMeta.new(
              url,
              source_url,
              meta.title,
              meta.keywords,
              meta.description,
              last_update
            )
          )

          SiteStatistics.update_count(SiteStatistic.new(source_url))

          parse_links(links, source_url)

        {:error, error} ->
          raise error
      end
    end
  end

  defp parse_links(links, source_url) do
    Enum.with_index(links, fn link, index ->
      time = Timex.now() |> Timex.shift(seconds: (index + 1) * Enum.random(@delay_interval))

      case UrlService.normalize(link, source_url) do
        {:ok, link} -> JobDispatcher.dispatch(LinkParse.new(link, source_url, time))
        {:error, error} -> {:error, error}
      end
    end)
  end
end
