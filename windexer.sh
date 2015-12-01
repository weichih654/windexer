#!/bin/bash

if [ -z "$@" ]; then
    folders=("./")
else
    folders=($@)
fi
filetype=("*.c" "*.h")
FINDCMD="/usr/bin/find"
CREATE_INDEX_CMD="/usr/bin/cscope -b"

#compose file path
for f in "${folders[@]}"
do
    FILEPATH=${f}
    if [ "${f:0:1}" == "/" ]; then
        :
    else
        FILEPATH=`pwd`/${FILEPATH}
    fi
    # Check directory exist
    if [ -d "${FILEPATH}" ]; then
        FINDCMD="${FINDCMD} ${FILEPATH}"
    fi
done

#compose file type
first=0
for f in "${filetype[@]}"
do
    if [ ${first} -eq 0 ];then
        first=1
    else
        FINDCMD="${FINDCMD} -o"
    fi
    FINDCMD="${FINDCMD} -name \"${f}\" -type f -printf \"\\\"%p\\\"\n\""
done
eval ${FINDCMD}

if [ ! -f "cscope.files" ];then
  eval ${FINDCMD} > cscope.files
fi
${CREATE_INDEX_CMD}
