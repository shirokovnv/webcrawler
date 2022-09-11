defmodule WebcrawlerWeb.CrawlLive do
  @moduledoc """
    Crawl service live
  """

  use WebcrawlerWeb, :live_view

  alias Webcrawler.Services.{CrawlService, UrlService}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, message: nil, error: nil)}
  end

  def handle_event("add", %{"url_value" => url_value}, socket) do
    CrawlService.add_link(url_value)

    {:noreply, assign(socket, message: "Link added to the queue", error: nil)}
  rescue
    FunctionClauseError ->
      {:noreply, assign(socket, message: nil, error: "Something went wrong")}
  end

  def handle_event("validate", %{"url_value" => url_value}, socket) do
    case UrlService.normalize(url_value, url_value) do
      {:ok, _url} -> {:noreply, assign(socket, error: nil)}
      {:error, error} -> {:noreply, assign(socket, error: error)}
    end
  end
end
