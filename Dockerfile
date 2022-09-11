# Find eligible builder and runner images on Docker Hub. We use Ubuntu/Debian instead of
# Alpine to avoid DNS resolution issues in production.
#
# https://hub.docker.com/r/hexpm/elixir/tags?page=1&name=ubuntu
# https://hub.docker.com/_/ubuntu?tab=tags
#
#
# This file is based on these images:
#
#   - https://hub.docker.com/r/hexpm/elixir/tags - for the build image
#   - https://pkgs.org/ - resource for finding needed packages
#   - Ex: hexpm/elixir:1.12.3-erlang-23.2.7-debian-bullseye-20210902-slim
#
ARG ELIXIR_VERSION=1.12.3
ARG OTP_VERSION=23.2.7
ARG DEBIAN_VERSION=bullseye-20210902-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"

ARG APP_PORT=4000

FROM ${BUILDER_IMAGE} as builder

# Install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Install mix dependencies
RUN mix deps.get

# Compile the project
RUN mix compile

# Expose the App port
EXPOSE ${APP_PORT}

# Set the entrypoint
CMD ["/app/entrypoint.sh"]