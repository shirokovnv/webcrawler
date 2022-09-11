defmodule Webcrawler.Services.HtmlService do
  @moduledoc """
    HTML service
  """

  alias Webcrawler.Models.HtmlMetadata

  @spec parse_links(binary, binary) :: {:error, binary} | {:ok, list(binary)}
  def parse_links(html, source_url) do
    parse_document(html, &do_parse_links/2, source_url: source_url)
  end

  @spec parse_meta(binary) :: {:error, binary} | {:ok, HtmlMetadata.t()}
  def parse_meta(html) do
    parse_document(html, &do_parse_meta/2)
  end

  defp parse_document(html, callback, options \\ []) do
    case Floki.parse_document(html) do
      {:ok, document} -> {:ok, callback.(document, options)}
      {:error, error} -> {:error, error}
    end
  end

  defp do_parse_links(document, options) do
    document
    |> Floki.find("a")
    |> Floki.attribute("href")
    |> Enum.map(fn link ->
      if String.contains?(link, "http") do
        link
      else
        options[:source_url] <> link
      end
    end)
  end

  defp do_parse_meta(document, _options) do
    title = Floki.find(document, "title") |> Floki.text()

    keywords =
      Floki.find(document, "meta[name=keywords]")
      |> Floki.attribute("content")
      |> Floki.text()

    description =
      Floki.find(document, "meta[name=description]")
      |> Floki.attribute("content")
      |> Floki.text()

    HtmlMetadata.new(title, keywords, description)
  end
end
