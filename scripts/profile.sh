PROD1_PROFILE=prod1
PROD2_PROFILE=prod2
PROD1_PORT=8087
PROD2_PORT=8088

function find_idle_profile() {
  RESPONSE_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/profile)

  if [ "${RESPONSE_CODE}" -ge 400 ]
  then
    CURRENT_PROFILE=${PROD2_PROFILE}
  else
    CURRENT_PROFILE=$(curl -s http://localhost/profile)
  fi

  if [ "${CURRENT_PROFILE}" == ${PROD1_PROFILE} ]
  then
    IDLE_PROFILE=${PROD2_PROFILE}
  else
    IDLE_PROFILE=${PROD1_PROFILE}
  fi

  echo "${IDLE_PROFILE}"
}

function find_idle_port() {
    IDLE_PROFILE=$(find_idle_profile)

    if [ "${IDLE_PROFILE}" == ${PROD1_PROFILE} ]
    then
      echo "${PROD1_PORT}"
    else
      echo "${PROD2_PORT}"
    fi
}
