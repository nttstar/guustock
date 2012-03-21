#!/usr/bin/env bash
nohup rails server -e production > server.log 2>&1 &
