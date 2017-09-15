#!/bin/bash -

# This is the boot script that will be executed when the container starts.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

# ensure that additional fonts are known to fontconfig
if [ -d /usr/share/fonts/external/ ]; then
  if [ "$(ls -A /usr/share/fonts/external/)" ]; then
    echo "You supplied additional fonts in folder '/usr/share/fonts/external/'."
    echo "We will now use 'fc-cache' to make them known to XeLaTeX et al." 
    fc-cache -fv /usr/share/fonts/external/
    echo "Done making additional fonts available."
  fi
fi

# enter the folder where the document is expected
cd /doc/

command=${1:-}
if [[ -n "$command" ]]
then
# We now execute the user-provided command.
  echo "The command '$command' with arguments '${@:2}' was specified. Now executing this command."
# We allow command to fail in order to be able to capture their return value.
  set +o errexit
  "$command" "${@:2}"
  retVal=$?
  set -o errexit
  if(("$retVal" != 0)) ; then
    echo "Error: Command '$command' returned '$retVal' when executed with arguments '${@:2}'."
  else
    echo "Successfully finished executing command '$command' with arguments '${@:2}'."
# We now look heuristically for generated pdf documents in order to set their permission.
# We first try to find a document name in the command line arguments.
    for var in "${@:2}"
    do
      document="${var%%.*}"
      if [[ -n "$document" ]]; then
        if [ -f "$document.pdf" ]; then
          echo "'$document.pdf' was found. Setting its permissions to 'chmod 777 $document.pdf' to make it available outside container."
          chmod 777 "$document.pdf" || true
          echo "Now exiting container."
          exit
        fi
      fi
    done
# The above will fail if tools like 'make' are employed, as is the case in ustc thesis.
# We therefore apply an additional heuristic.
    for document in main paper thesis article report book
    do
      if [ -f "$document.pdf" ]; then
        echo "'$document.pdf' was found. Setting its permissions to 'chmod 777 $document.pdf' to make it available outside container."
        chmod 777 "$document.pdf" || true
        echo "Now exiting container."
        exit
      fi
    done
  fi
  echo "Now exiting container."
  exit $retVal
else
# open a shell
  set +o pipefail  # no longer trace ERR through pipes
  set +o errtrace  # no longer trace ERR through 'time command' and other functions
  set +o nounset   # no longer exit the script if you try to use an uninitialized variable
  set +o errexit   # no longer exit the script if any statement returns a non-true return value
  /bin/bash -l
fi
