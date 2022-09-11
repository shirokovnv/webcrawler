defmodule WebcrawlerWeb.ResultsLive do
  @moduledoc """
    Results page live
  """

  use WebcrawlerWeb, :live_view

  alias Webcrawler.Repo.Sites
  alias Webcrawler.Services.UrlService

  @update_interval 60_000

  def mount(params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, @update_interval)

    {state, url, links} = get_state_and_links(params["url_hash"])

    {:ok, assign(socket, url_hash: params["url_hash"], url: url, state: state, links: links)}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, @update_interval)

    {state, url, links} = get_state_and_links(socket.url_hash)

    {:ok, assign(socket, url: url, state: state, links: links)}
  end

  defp get_state_and_links(url_hash) do
    case UrlService.from_base64(url_hash) do
      {:ok, url} ->
        links = Sites.get_by_source_url(url)
        {"ok", url, links}

      :error ->
        {"not_found", url_hash, []}
    end
  end
end
