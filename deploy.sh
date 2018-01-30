#!/bin/bash

SEMAPHORE_URL=http://159.65.10.143:3000

# -----------------------------------
# update docker tag in semaphore

read -r -d '' BODY <<- EOM
    {
      "id": 1,
      "name": "deployment",
      "project_id": 1,
      "password": null,
      "json": "{ \"docker_tag\": \"${DRONE_COMMIT_SHA}\"  }",
      "removed": false
    }
EOM

curl -X PUT --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  --header "Authorization: Bearer ${SEMAPHORE_TOKEN}" \
  -d "${BODY}" \
  ${SEMAPHORE_URL}/api/project/1/environment/1 -v

# ---------------------------------------
# enqueue tasks

read -r -d '' BODY <<- EOM
  {
    "template_id": 1
  }
EOM

curl -X POST --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  --header "Authorization: Bearer ${SEMAPHORE_TOKEN}" \
  -d "${BODY}" \
  ${SEMAPHORE_URL}/api/project/1/tasks -v

# trigger build
