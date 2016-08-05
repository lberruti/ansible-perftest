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
for v in upstream/stable-1.9 upstream/performance_improvements; do
  go_to $v > /dev/null
  cat <<EOF
******************** $v
EOF
  $ANSIBLE_HOME/bin/ansible-playbook --version
  for play in perftest perftest_no_includes; do
    cat <<EOF
*** $play
EOF
    play_run $play.yml $*
  done
done
