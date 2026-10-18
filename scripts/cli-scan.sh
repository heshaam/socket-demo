#!/usr/bin/env bash
socket scan create \
  --org "heshaam-attar-org" \
  --repo "socket-demo" \
  --branch main \
  --report --workspace "Demo" \
  --cwd ../ \
  .