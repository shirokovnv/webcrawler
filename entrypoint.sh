#!/bin/bash
# Docker entrypoint script.

# Wait until DB is ready.
echo "$(date) - waiting for database to start"
sleep 2

exec mix phx.server