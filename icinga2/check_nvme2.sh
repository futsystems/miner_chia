

#!/bin/bash
set -o errexit -o nounset -o pipefail
export LC_ALL=C
# Checks for NVMe disks. nmve-cli must be installed.
#
# Author: Tomas Barton
# Requirements:
# nvme-cli - git clone https://github.com/linux-nvme/nvme-cli
#
# Usage:
# ./check_nvme /dev/nvme0n1
#
function -h {
  cat <<USAGE
   USAGE: Check for NVMe drive state
   -d / --disk     disk device to check
   -p / --path     path to nvme binary (default: /usr/sbin)
   -v / --verbose  debugging output
      ./check_nvme -d /dev/nvme0n1
USAGE
}; function --help { -h ;}

function msg { out "$*" >&2 ;}
function out { printf '%s\n' "$*" ;}
function err { local x=$? ; msg "$*" ; return $(( $x == 0 ? 1 : $x )) ;}

function main {
  local path='/usr/sbin'
  local verbose=false
  local use_sudo="true"
  while [[ $# -gt 0 ]]
  do
    case "$1" in                                      # Munging globals, beware
      -d|--disk)            DISK="$2"; shift 2 ;;
      -p|--path)            path="$2"; shift 2 ;;
      -s|--sudo)            use_sudo="$2"; shift 2 ;;
      -v|--verbose)         verbose=true; shift 1 ;;
      *)                    err 'Argument error. Please see help: -h' ;;
    esac
  done
  if [[ $verbose == true ]]; then
    set -ex
  fi

  local CRIT=false
  local MESSAGE=""

  # make sure disk is a block device
  if [ ! -b $DISK ]; then
    CRIT=true
    MESSAGE="$MESSAGE $DISK is missing!"
  fi
  local prefix=""
  if [ "${use_sudo}" == "true" ]; then
    prefix="sudo "
  fi

  # capture disk SMART log
  LOG=$(${prefix}${path}/nvme smart-log ${DISK})

  # Check for critical_warning
  # Double quotes preserve whitespaces (new lines) -- must remain
  $(echo "$LOG" | awk 'FNR == 2 && $3 != 0 {exit 1}')
  if [ $? == 1 ]; then
    CRIT=true
    MESSAGE="$MESSAGE $DISK has critical warning "
  fi

  # Check media_errors
  $(echo "$LOG" | awk 'FNR == 15 && $3 != 0 {exit 1}')
  if [ $? == 1 ]; then
    CRIT=true
    MESSAGE="$MESSAGE $DISK has media errors "
  fi

  # Check num_err_log_entries
  $(echo "$LOG" | awk 'FNR == 16 && $3 != 0 {exit 1}')
  if [ $? == 1 ]; then
    CRIT=true
    MESSAGE="$MESSAGE $DISK has errors logged "
  fi

  if [ $CRIT = "true" ]; then
    echo "CRITICAL: $MESSAGE"
    exit 2
  else
    READ=$(echo "$LOG" |  awk 'FNR == 9 {print $3}' | sed 's/,//g')
    WRITE="$(echo "$LOG" | awk 'FNR == 10 {print $3}' | sed 's/,//g')"
    msg "OK $(echo $DISK)|read=${READ};;; write=${WRITE};;;"
    exit 0
  fi
}

if [[ ${1:-} ]] && declare -F | cut -d' ' -f3 | fgrep -qx -- "${1:-}"
then
  case "$1" in
    -h|--help) : ;;
    *) ;;
  esac
  "$@"
else
  main "$@"
fi