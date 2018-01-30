#!/bin/bash

# ------------------------
# ENV: YOU HAVE TO INJECT THESE VARIABLES THROUGH DRONE SECRETS

# SEMAPHORE_URL
# SEMAPHORE_USERNAME
# SEMAPHORE_PASSWORD

echo ${SEMAPHORE_URL}
echo ${SEMAPHORE_USERNAME}
echo ${SEMAPHORE_PASSWORD}

# -----------------------------------
# login to get cookie

read -r -d '' BODY <<- EOM
  {
    "auth": "${SEMAPHORE_USERNAME}",
    "password": "${SEMAPHORE_PASSWORD}"
  }
EOM

echo 'BODY='
echo $BODY

curl -v -b /tmp/semaphore-cookie -X POST \
  --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  -d "${BODY}" \
  ${SEMAPHORE_URL}/api/auth/login 2>&1

OUTPUT=`curl -vs -b /tmp/semaphore-cookie ${SEMAPHORE_URL}/api/user/tokens 2>&1`

echo "OUTPUT=$OUTPUT"

echo "$OUTPUT" | grep -Po "(?<=id\":\")[^\"]+(?=\")"

echo "TOKEN=$TOKEN"

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

curl -vs -X PUT \
  --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  --header "Authorization: Bearer ${TOKEN}" \
  -d "${BODY}" \
  ${SEMAPHORE_URL}/api/project/1/environment/1 2>&1

# ---------------------------------------
# enqueue tasks

read -r -d '' BODY <<- EOM
  {
    "template_id": 1
  }
EOM

curl -vs -X POST \
  --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  --header "Authorization: Bearer ${TOKEN}" \
  -d "${BODY}" \
  ${SEMAPHORE_URL}/api/project/1/tasks 2>&1
