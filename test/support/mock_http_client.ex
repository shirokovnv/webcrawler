defmodule FakeHttpClient do
  @moduledoc false

  defstruct []
end

defimpl Webcrawler.Services.HttpParsing, for: FakeHttpClient do
  @available_schemas ["http", "https"]
  @fake_response """
  <!doctype html>
  <html>
  <head>
    <title>Title</title>
  </head>
  <body>
  </body>
  </html>
  """

  def parse_http_response(_client, url) do
    uri = URI.parse(url)

    if Enum.member?(@available_schemas, uri.scheme) do
      {:ok, @fake_response}
    else
      {:error, "Not a valid URL"}
    end
  end
end
