#!/bin/bash

# ----------------
# INPUT AND USAGE
# ----------------

function usage()
{
  cat << HEREDOC
Usage: docker-test [OPTIONS]

Options:
 -h, --help           Display this help message
 -v|vv|vvv, --verbose Increase the verbosity of messages: 1 for normal output, 2 for more verbose output and 3 for debug
 --stop-on-failure    Stops after the first failing test
HEREDOC
}

# process input
OPTS=$(getopt -o "hn:t:v" --long "help,num:,time:,verbose,dry-run" -n "$(basename "$0")" -- "$@")
if [ $? != 0 ] ; then echo "Error in command line arguments." >&2 ; usage; exit 1 ; fi
eval set -- "$OPTS"

TEST_COUNT=0
FAILED_TEST_COUNT=0
STOP_ON_FAILURE=0
VERBOSE=0

while true; do
  case "$1" in
    -h | --help ) usage; exit; ;;
    --stop-on-failure ) STOP_ON_FAILURE=1; shift ;;
    -v | --verbose ) VERBOSE=$((VERBOSE + 1)); shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

# ----------------
# TEST HELPERS
# ----------------

function testGroup() {
  echo -e "\n$1\n" | pr -to 4
}

function test() {
  TEST_RESULT="$?"
  TEST_COUNT=$((TEST_COUNT+1))

  if [[ $TEST_RESULT == "0" ]]; then
    echo -e "\e[32m✔︎ \e[0m $1" | pr -to 4
  else
    echo -e "\e[31m✘ \e[0m $1" | pr -to 4
    FAILED_TEST_COUNT=$((FAILED_TEST_COUNT+1))
    if [[ $STOP_ON_FAILURE == 1 ]]; then
        finish
    fi
  fi
}

function setup() {
    make docker-init > /dev/null 2>&1
    make docker-up > /dev/null 2>&1
}

function finish() {
    if [[ $FAILED_TEST_COUNT -gt 0 ]]; then
      echo -e "\nFAILED $TEST_COUNT tests, $FAILED_TEST_COUNT failures"
      teardown 1
    else
      echo -e "\nOK $TEST_COUNT tests, $FAILED_TEST_COUNT failures"
      teardown 0
    fi
}

function teardown() {
    make docker-down > /dev/null 2>&1
    exit $1
}

setup

# ----------------
# TESTS BEGIN
# ----------------

DOCKER_COMPOSE="docker-compose -f ./.docker/docker-compose.yml --project-directory ./.docker"

testGroup "Test workspace container"

test 'Container is running' "$(
  $DOCKER_COMPOSE ps | grep "workspace"
)"

test 'php version is 7.4' "$(
  $DOCKER_COMPOSE exec workspace php -v | grep "PHP 7.4"
)"

test 'php xdebug installed' "$(
  $DOCKER_COMPOSE exec workspace php -m | grep "xdebug"
)"

test 'Zend OPcache installed' "$(
  $DOCKER_COMPOSE exec workspace php -m | grep "Zend OPcache"
)"

test 'host.docker.internal is correct' "$(
  $DOCKER_COMPOSE exec workspace dig host.docker.internal | grep -v NXDOMAIN
)"

test 'Composer is installed' "$(
  $DOCKER_COMPOSE exec workspace composer --version | grep -q "Composer"
)"

testGroup "Test php-fpm container"

test 'Container is running' "$(
  $DOCKER_COMPOSE ps | grep "php-fpm"
)"

test 'php version is 7.4' "$(
  $DOCKER_COMPOSE exec php-fpm php -v | grep "PHP 7.4"
)"

test 'php xdebug installed' "$(
  $DOCKER_COMPOSE exec php-fpm php -m | grep "xdebug"
)"

test 'Zend OPcache installed' "$(
  $DOCKER_COMPOSE exec php-fpm php -m | grep "Zend OPcache"
)"

test 'host.docker.internal is correct' "$(
  $DOCKER_COMPOSE exec php-fpm dig host.docker.internal | grep -v NXDOMAIN
)"

testGroup "Test nginx container"

test 'Container is running' "$(
  $DOCKER_COMPOSE ps | grep "nginx"
)"

test 'Test it is available on localhost' "$(
  curl -sS -IX GET 127.0.0.1 | grep -q "200 OK"
)"

# ----------------
# TESTS END
# ----------------

finish
