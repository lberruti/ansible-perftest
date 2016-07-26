#!/bin/bash

go_to() {
  cd $ANSIBLE_HOME
  git co -q $1
  git submodule update -q
  find . -name \*.pyc | xargs rm
  cd -
}

play_run() {
  time python -m cProfile -s time $ANSIBLE_HOME/bin/ansible-playbook -i inventory $* | \
    grep -A 10 'function calls'
}

set -u
for v in upstream/stable-1.9 v2.1.1.0-0.5.rc5 upstream/devel; do
  go_to $v > /dev/null
  cat <<EOF
********************************************************************************
EOF
  $ANSIBLE_HOME/bin/ansible-playbook --version
  play_run perftest.yml $*
done
