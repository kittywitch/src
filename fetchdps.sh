#!/usr/bin/env bash
set -euo pipefail

if [ -z "${DPSREPORT_USER_TOKEN+x}" ]; then
  echo "Please set \$DPSREPORT_USER_TOKEN to the one provided by dps.report!"
  exit 1
fi

args=$(getopt -a -o :c:d: --long :days,:count,help -- "$@")

usage(){
  cat <<EOF
Usage: $0
 [ -d input | --days input ]: Filter to only get submissions from input days ago.
 [ -c input | --count input ]: Return this many submissions from the API (default is 25 if unset)
EOF
  exit 1
}

eval set -- ${args}
while :
do
  case $1 in
	-d | --days) DAYS_AGO="$2" ; shift 2 ;;
	-c | --count) REQUEST_COUNT="$2" ; shift 2 ;;
    --) shift; break ;;
    *) >&2 echo Unsupported option: $1
       usage ;;
  esac
done

REPORT_OPTARGS=""
if [ -n "${DAYS_AGO+x}" ]; then
  START_OF_DAY=$(date --date "00:00 $DAYS_AGO days ago" '+%s')
  END_OF_DAY=$(date --date "23:59:59 $DAYS_AGO days ago" '+%s')
  REPORT_OPTARGS="$REPORT_OPTARGS --data since=$START_OF_DAY --data untilEncounter=$END_OF_DAY"
fi
if [ -n "${REQUEST_COUNT+x}" ]; then
  REPORT_OPTARGS="$REPORT_OPTARGS --data perPage=$REQUEST_COUNT"
fi
REPORT=$(curl -G https://dps.report/getUploads $REPORT_OPTARGS --data userToken=$DPSREPORT_USER_TOKEN)
JQOUT="$(echo "$REPORT" | jq -r '(.uploads | reverse | .[] | select(.encounter.success == true) | "\(.encounter.boss) - \(.encounterTime | todate) - \(.permalink)")')"
echo -e "$JQOUT"
