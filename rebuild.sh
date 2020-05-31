#!/bin/bash
docker-compose rm --stop -f
docker-compose build --no-cache
docker-compose up -d
