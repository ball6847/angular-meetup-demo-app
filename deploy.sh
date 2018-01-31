#!/bin/bash

# ------------------------
# ENV: YOU HAVE TO INJECT THESE VARIABLES THROUGH DRONE SECRETS

# SEMAPHORE_URL
# SEMAPHORE_TOKEN
# SEMAPHORE_PROJECT_ID
# SEMAPHORE_ENVIRONMENT_ID
# SEMAPHORE_TEMPLATE_ID

# -----------------------------------
# update docker tag in semaphore

read -r -d '' BODY <<- EOM
  {
    "id": ${SEMAPHORE_ENVIRONMENT_ID},
    "name": "deployment",
    "project_id": ${SEMAPHORE_PROJECT_ID},
    "password": null,
    "json": "{ \"docker_tag\": \"${DRONE_COMMIT_SHA}\"  }",
    "removed": false
  }
EOM

curl -vs -X PUT \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H "Authorization: Bearer ${SEMAPHORE_TOKEN}" \
  -d "${BODY}" \
  ${SEMAPHORE_URL}/api/project/${SEMAPHORE_PROJECT_ID}/environment/${SEMAPHORE_ENVIRONMENT_ID} 2>&1

# ---------------------------------------
# enqueue tasks

read -r -d '' BODY <<- EOM
  {
    "template_id": ${SEMAPHORE_TEMPLATE_ID}
  }
EOM

curl -vs -X POST \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H "Authorization: Bearer ${SEMAPHORE_TOKEN}" \
  -d "${BODY}" \
  ${SEMAPHORE_URL}/api/project/${SEMAPHORE_PROJECT_ID}/tasks 2>&1
