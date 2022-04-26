#!/bin/bash

export PYTHONPATH=/asksonic/deps
export PATH="$PATH:/asksonic/deps/bin"

PORT=8080
cd asksonic

if [ "${FLASK_ENV}" == development ]; then
    python server.py
else
    gunicorn asksonic:app --bind "${ASKS_HOST:-0.0.0.0}:${ASKS_PORT:-$PORT}" --workers 1
fi
