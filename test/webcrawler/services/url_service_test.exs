defmodule Webcrawler.Services.UrlServiceTest do
  use ExUnit.Case
  alias Webcrawler.Services.UrlService

  @url "https://example.com"
  @foo_url "https://example.com/foo"
  @bar_url "https://mysite.com/bar"
  @mailto_url "mailto:example@mail.com"
  @tel_url "tel:000-111-222"
  @url_hash "aHR0cHM6Ly9leGFtcGxlLmNvbQ=="
  @not_a_base64_str "random string"

  describe "test base64 encode and decode" do
    test "encodes URL to base64 format" do
      assert @url_hash == UrlService.to_base64(@url)
    end

    test "decodes URL from base64 format" do
      assert {:ok, @url} == UrlService.from_base64(@url_hash)
      assert :error == UrlService.from_base64(@not_a_base64_str)
    end
  end

  test "check URL is external" do
    assert false == UrlService.external?(@foo_url, @url)
    assert true == UrlService.external?(@bar_url, @url)
  end

  test "URL normalization" do
    assert {:ok, @url} == UrlService.normalize(@url, @url)
    assert {:ok, @url} == UrlService.normalize(@url <> "/", @url)
    assert {:ok, @foo_url} == UrlService.normalize(@foo_url <> "#fragment", @foo_url)
    assert {:error, "Not a valid URL"} == UrlService.normalize(@mailto_url, @url)
    assert {:error, "Not a valid URL"} == UrlService.normalize(@tel_url, @url)
    assert {:error, "Not a valid URL"} == UrlService.normalize("", @url)
  end
end
