defmodule Webcrawler.Services.HtmlServiceTest do
  use ExUnit.Case

  alias Webcrawler.Models.HtmlMetadata
  alias Webcrawler.Services.HtmlService

  @source_url "https://example.com"
  @html """
  <!doctype html>
  <html>
  <head>
  <meta name="keywords" content="keywords" />
  <meta name="description" content="description" />
  <title>Title</title>
  <body>
    <div id="content">
      <a href="https://example.com/foo">Link 1</a>
      <a href="https://example.com/bar">Link 2</a>
    </div>
  </body>
  </html>
  """

  test "Parse HTML links" do
    {:ok, links} = HtmlService.parse_links(@html, @source_url)
    assert is_list(links)

    Enum.each(links, fn link ->
      assert String.contains?(link, @source_url)
    end)
  end

  test "Parse HTML meta" do
    {:ok, %HtmlMetadata{} = meta} = HtmlService.parse_meta(@html)

    assert "Title" == meta.title
    assert "keywords" == meta.keywords
    assert "description" == meta.description
  end
end
