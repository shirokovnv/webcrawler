defmodule Webcrawler.JobDispatcher do
  @moduledoc """
    Dispatcher for the application jobs
  """

  alias Webcrawler.Jobs.LinkParse
  alias Webcrawler.Workers.LinkParser

  @default_queue "default"

  @spec dispatch(map) :: {:ok, any}
  def dispatch(job) do
    case job do
      %LinkParse{} ->
        {:ok, _ack} =
          Exq.enqueue_at(Exq, @default_queue, job.schedule_at, LinkParser, [
            job.url,
            job.source_url
          ])

      _ ->
        raise "Unknown job"
    end
  end
end
