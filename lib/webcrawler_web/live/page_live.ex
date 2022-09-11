defmodule WebcrawlerWeb.PageLive do
  @moduledoc """
    Main page live
  """

  use WebcrawlerWeb, :live_view

  alias Webcrawler.Repo.SiteStatistics
  alias Webcrawler.Services.UrlService

  @update_interval 5000

  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, @update_interval)

    stat = map_results()
    {:ok, assign(socket, site_statistics: stat)}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, @update_interval)

    stat = map_results()
    {:noreply, assign(socket, site_statictics: stat)}
  end

  defp map_results do
    SiteStatistics.all()
    |> Enum.map(fn stat ->
      url_hash = UrlService.to_base64(stat.source_url)

      Map.put(stat, :url_hash, url_hash)
    end)
  end
end
