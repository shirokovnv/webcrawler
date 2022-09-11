defmodule Webcrawler.Services.CrawlServiceTest do
  use ExUnit.Case

  alias Webcrawler.Services.CrawlService

  @url "https://example.com"

  test "Adds a job for parsing URL" do
    assert [] = Exq.Mock.jobs()

    CrawlService.add_link(@url)

    assert [
             %Exq.Support.Job{
               args: [@url, @url],
               class: Webcrawler.Workers.LinkParser,
               queue: "default"
             }
           ] = Exq.Mock.jobs()
  end
end
