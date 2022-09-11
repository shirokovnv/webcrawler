defmodule Webcrawler.Repo.SiteStatistics do
  @moduledoc """
    Site statistics repo
  """

  alias Webcrawler.Models.SiteStatistic

  @conn Application.compile_env(:webcrawler, :xandra)[:name]

  def all do
    with {:ok, prepared} <-
           Xandra.prepare(
             @conn,
             "SELECT * FROM storage.site_statistics"
           ),
         {:ok, %Xandra.Page{} = page} <-
           Xandra.execute(@conn, prepared, []),
         do:
           Enum.to_list(page)
           |> Enum.map(fn rows ->
             SiteStatistic.new(
               rows["source_url"],
               rows["links_count"]
             )
           end)
  end

  def update_count(%SiteStatistic{} = stat) do
    prepared_update =
      Xandra.prepare!(
        @conn,
        "UPDATE storage.site_statistics SET links_count = links_count + 1 WHERE source_url = ?"
      )

    Xandra.execute!(@conn, prepared_update, [_source_url = stat.source_url])
  end
end
