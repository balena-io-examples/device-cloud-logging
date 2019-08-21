#!/bin/bash

# If we do not have a loggly url to post to, we store to the
# volume on the device - note that this can fill up
# eventually, as no log rotation is implemented
while true;
do
	if [ -z "${LOGGLY_URL}" ]; then
		curl -X POST -H "Content-Type: application/json" --no-buffer --data '{"follow":true,"all":true,"format":"short"}' "$BALENA_SUPERVISOR_ADDRESS/v2/journal-logs?apikey=$BALENA_SUPERVISOR_API_KEY" > /logs/log.journal
	else
		curl -X POST -H "Content-Type: application/json" --no-buffer --data '{"follow":true,"all":true,"format":"short"}' "$BALENA_SUPERVISOR_ADDRESS/v2/journal-logs?apikey=$BALENA_SUPERVISOR_API_KEY" \
		| while read -r line ;
			do
				curl -s -H "content-type:text/plain" -d "${line}" "${LOGGLY_URL}";
			done
	fi
done
