defmodule Webcrawler.Repo.Sites do
  @moduledoc """
    Sites repo
  """

  alias Webcrawler.Models.Site

  @conn Application.compile_env(:webcrawler, :xandra)[:name]

  @spec exists?(binary) :: boolean
  def exists?(url) do
    {:ok, prepared} = Xandra.prepare(@conn, "SELECT * FROM storage.sites WHERE url = ?")
    links_count = Xandra.execute!(@conn, prepared, [_url = url]) |> Enum.count()

    links_count > 0
  end

  def create(%Site{} = site) do
    prepared_insert =
      Xandra.prepare!(
        @conn,
        "INSERT INTO storage.sites (url, source_url, html, last_update) VALUES (?, ?, ?, ?)"
      )

    Xandra.execute!(@conn, prepared_insert, [
      _url = site.url,
      site.source_url,
      site.html,
      site.last_update
    ])
  end

  def get_by_source_url(source_url) when is_binary(source_url) do
    with {:ok, prepared} <-
           Xandra.prepare(
             @conn,
             "SELECT * FROM storage.sites WHERE source_url = ? ALLOW FILTERING"
           ),
         {:ok, %Xandra.Page{} = page} <-
           Xandra.execute(@conn, prepared, [source_url]),
         do:
           Enum.to_list(page)
           |> Enum.map(fn rows ->
             Site.new(
               rows["url"],
               rows["source_url"],
               rows["html"],
               rows["last_update"]
             )
           end)
  end
end
