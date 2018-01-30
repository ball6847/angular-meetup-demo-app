#!/bin/bash

SEMAPHORE_URL=http://159.65.10.143:3000

curl -X PUT --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  --header 'Authorization: Bearer ${SEMAPHORE_TOKEN}' \
  -d '{ "docker_tag": "${DRONE_COMMIT_SHA}" }' \
  ${SEMAPHORE_URL}/api/project/1/environment/1 -v
