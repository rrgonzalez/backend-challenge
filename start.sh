#!/bin/bash

docker stop mongo-ebc-container
docker rm mongo-ebc-container

docker run --name mongo-ebc-container \
  -e MONGO_INITDB_DATABASE=everlywell_backend_challenge_development \
  -p 27017:27017  \
  -v mongodb_ebc_data_container:/data/ebc_db  \
  -d mongo

bundle exec rails s -p 3000
