defmodule WebcrawlerWeb.SearchLive do
  @moduledoc """
    Search service live
  """

  use WebcrawlerWeb, :live_view

  alias Webcrawler.Repo.SitesByMeta

  def mount(_params, _session, socket) do
    {:ok, assign(socket, sites_by_meta: [])}
  end

  def handle_event("search", %{"search_field" => %{"query" => query}}, socket) do
    filtered_sites = SitesByMeta.filter(query)

    {:noreply, assign(socket, sites_by_meta: filtered_sites)}
  end
end
