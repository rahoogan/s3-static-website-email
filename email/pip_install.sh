#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

# Get Current directory (handle symlinks)
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# Placeholder for whatever data-fetching logic your script implements
sudo pip install -r $DIR/requirements.txt --quiet -t $DIR/

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
if [$? eq 0]
then
    echo '{"Python Requirements Installed": "True"}'
else
    echo '{"Python Requirements Installed": "False"}'
fi
