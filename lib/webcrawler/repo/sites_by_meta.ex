defmodule Webcrawler.Repo.SitesByMeta do
  @moduledoc """
    Sites by meta repo
  """

  alias Webcrawler.Models.SiteByMeta

  @conn Application.compile_env(:webcrawler, :xandra)[:name]

  def create(%SiteByMeta{} = site_by_meta) do
    prepared_insert =
      Xandra.prepare!(
        @conn,
        "INSERT INTO storage.sites_by_meta (url, source_url, title, keywords, description, last_update) VALUES (?, ?, ?, ?, ?, ?)"
      )

    Xandra.execute!(@conn, prepared_insert, [
      _url = site_by_meta.url,
      site_by_meta.source_url,
      site_by_meta.title,
      site_by_meta.keywords,
      site_by_meta.description,
      site_by_meta.last_update
    ])
  end

  def filter(query) do
    case query do
      "" ->
        []

      nil ->
        []

      search_query ->
        by_title = filter_by(search_query, "title")
        by_keywords = filter_by(search_query, "keywords")
        by_description = filter_by(search_query, "description")

        Enum.uniq(by_title ++ by_keywords ++ by_description)
    end
  end

  defp filter_by(query, field_name) do
    filter = "%#{query}%"

    with {:ok, prepared} <-
           Xandra.prepare(
             @conn,
             "SELECT * FROM storage.sites_by_meta WHERE #{field_name} LIKE ?"
           ),
         {:ok, %Xandra.Page{} = page} <-
           Xandra.execute(@conn, prepared, [filter]),
         do:
           Enum.to_list(page)
           |> Enum.map(fn rows ->
             SiteByMeta.new(
               rows["url"],
               rows["source_url"],
               rows["title"],
               rows["keywords"],
               rows["description"],
               rows["last_update"]
             )
           end)
  end
end
