defmodule Webcrawler.Services.HttpClient do
  @moduledoc """
    Module represents http client dependency
  """

  defstruct []
end

defprotocol Webcrawler.Services.HttpParsing do
  @spec parse_http_response(any, binary) :: {:error, any} | {:ok, binary}
  def parse_http_response(client, url)
end

defimpl Webcrawler.Services.HttpParsing, for: Webcrawler.Services.HttpClient do
  @success_status 200
  @redirect_to_https_status 308

  def parse_http_response(term, url) do
    %HTTPoison.Response{
      body: body,
      headers: headers,
      status_code: status_code
    } = HTTPoison.get!(url, [], follow_redirect: true)

    case status_code do
      @success_status ->
        {:ok, body}

      @redirect_to_https_status ->
        headers = headers |> Enum.into(%{})
        parse_http_response(term, headers["Location"] || "")

      _ ->
        {:error, "Wrong status #{status_code}"}
    end
  rescue
    error in HTTPoison.Error -> {:error, error}
  end
end

defmodule Webcrawler.Services.HttpParser do
  @moduledoc """
    HTTP Parser
  """

  alias Webcrawler.Services.HttpParsing

  @spec parse_http_response(binary, any) :: {:error, any} | {:ok, binary}
  def parse_http_response(url, client \\ %Webcrawler.Services.HttpClient{}) do
    HttpParsing.parse_http_response(client, url)
  end
end
