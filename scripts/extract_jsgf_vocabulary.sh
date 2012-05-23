#!/bin/sh

if [ $# -ne 1 ]
then
  echo "Usage: `basename $0` jsgf"
  exit 65
fi

sphinx_jsgf2fsg -jsgf $1 2>/dev/null | egrep "^TRANSITION( +\S+){4}$" | awk '{print($5)}' | sort | uniq
