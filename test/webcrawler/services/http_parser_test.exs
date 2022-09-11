defmodule Webcrawler.Services.HttpClientTest do
  use ExUnit.Case

  alias Webcrawler.Services.HttpParser

  @url "https://example.com"
  @bad_url "//foo"

  test "Parses HTML" do
    {:ok, html} = HttpParser.parse_http_response(@url, %FakeHttpClient{})
    assert String.contains?(html, "<!doctype html>")

    {:error, error} = HttpParser.parse_http_response(@bad_url, %FakeHttpClient{})
    assert "Not a valid URL" == error
  end
end
