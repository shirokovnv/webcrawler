defmodule Webcrawler.Services.UrlService do
  @moduledoc """
   URL service
  """

  @available_schemas ["http", "https"]
  @available_ports [80, 443]
  @default_scheme "https"

  @spec external?(binary, binary) :: boolean
  def external?(url, domain) do
    !String.contains?(url, domain)
  end

  @spec normalize(binary, binary) :: {:ok, binary} | {:error, binary}
  def normalize(url, source_url) do
    uri = URI.parse(url)
    domain = domain_from_url(source_url)

    if is_nil(uri.scheme) && is_nil(uri.host) do
      uri
      |> Map.put(:scheme, @default_scheme)
      |> Map.put(:host, domain)
    end

    with true <- Enum.member?(@available_schemas, uri.scheme),
         true <- Enum.member?(@available_ports, uri.port),
         false <- external?(url, domain) do
      uri =
        uri
        |> Map.put(:fragment, nil)
        |> URI.to_string()
        |> String.trim_trailing("/")

      {:ok, uri}
    else
      _ -> {:error, "Not a valid URL"}
    end
  end

  @spec to_base64(binary) :: binary
  def to_base64(url) when is_binary(url) do
    Base.url_encode64(url)
  end

  @spec from_base64(binary) :: :error | {:ok, binary}
  def from_base64(url) when is_binary(url) do
    Base.url_decode64(url)
  end

  defp domain_from_url(url) do
    uri = URI.parse(url)
    uri.host || ""
  end
end
