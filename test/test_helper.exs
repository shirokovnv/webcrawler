ExUnit.start()

# Start mock redis server
Exq.Mock.start_link(mode: :fake)
