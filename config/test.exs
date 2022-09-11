import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :webcrawler, WebcrawlerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "s8tuA/KXlGjk0Hsps5hYevmdHmH6hLDz3cuYSuzXWb3DcX/Runrqn99rjMZw91ef",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :webcrawler, :xandra, name: :xandra_connection

config :exq,
  queue_adapter: Exq.Adapters.Queue.Mock,
  start_on_application: false
