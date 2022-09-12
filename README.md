# Webcrawler

![ci.yml][link-ci]

**The service for crawling websites (experimental)**

## Dependencies

- [Docker][link-docker]
- [Make][link-make]
- [Phoenix framework][link-phx]
- [Redis][link-redis] for jobs processing
- [Cassandra][link-cassandra] for the persistent storage

## Project setup

**From the project root, inside shell, run:**

- `make pull` to pull latest images
- `make init` to install fresh dependencies
- `make up` to run app containers

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

- `make down` - to extinguish running containers
- `make help` - for additional commands

## Howitworks

1. The user adds new source URL -> new async job started
2. Inside the job:

- Normalize URL (validate schema, remove trailing slash, etc...)
- Store link in DB, if link already exists, than exit
- Parse HTML links and metadata
- Store it in different tables
- Normalize links, check wether it relational or not.
- Check links are external
- For each non-external link -> schedule new async job with some random interval

3. Thats literally it

**To see it in action, go to the** [localhost:4000/crawl](https://localhost:4000/crawl) **and type any kind of URL.**

**To see some search results visit** [localhost:4000/search](http://localhost:4000/search).

## Database schema

The default keyspace is `storage`

**Tables:**

- `site_statistics` contains source URLs and counting parsed links
- `sites` contains URL and HTML parsed
- `sites_by_meta` contains URL and parsed metadata

For `LIKE`-style search queries [SASI](link-sasi) index needs to be configured.

See `schema.cql` and `cassandra.yaml` for more detail.

## Useful links

- Visit [localhost:4000/jobs](http://localhost:4000/jobs) to see crawling jobs in action
- Visit [localhost:4000/dashboard](http://localhost:4000/dashboard) to see core metrics of the system

[link-ci]: https://github.com/shirokovnv/webcrawler/actions/workflows/ci.yml/badge.svg
[link-cassandra]: https://cassandra.apache.org/
[link-sasi]: https://cassandra.apache.org/doc/4.1/cassandra/cql/SASI.html
[link-docker]: https://www.docker.com/
[link-make]: https://www.gnu.org/software/make/manual/make.html
[link-redis]: https://redis.io/
[link-phx]: https://www.phoenixframework.org/
