#!/bin/bash
(( EUID != 0 )) && exec sudo -- "$0" "$@"
# exit codes:
# 0: Success
# 1: change_mac() received invalid argument
# 2: change_mac() returned >0 or MAC_ADDRESS is not set (should never occur)
# 5: User quit by prompt

AWK='/link/ { print $2 }'

OPTION_ONE="00:11:AA:BB:99:FF"
OPTION_TWO="FF:FF:FF:FF:00:00"
DEVICE_NAME="wlp16s0"

change_mac()
{
  if [ -z "${1}" ]; then  # executed without arguments
    if [ "$CURRENT_MAC" = "$OPTION_ONE" ]; then
      MAC_ADDRESS=$OPTION_TWO
    else
      MAC_ADDRESS=$OPTION_ONE
    fi

  elif [ ${2} = 2 ]; then  # executed with 2 chars as argument (end of mac)
    MAC_ADDRESS="A4:31:35:D5:C9:${1}"

  elif [ ${2} = 17 ]; then  # executed with 17 chars as argument (whole mac)
    MAC_ADDRESS="${1}"

  else  # invalid argument
    echo "Weird Argument given!"
    exit 1
  fi

  return 0  # success
}

get_current_mac()
{
  CURRENT_MAC=$(ip link show ${DEVICE_NAME} | awk "${AWK}" | tr [:lower:] [:upper:])
  return 0
}

init_vars()
{
  for var in DEVICE_NAME OPTION_ONE OPTION_TWO; do
    env_var="MC_$var"
    value="${!env_var}"
    if [ -z "${!env_var}" ]; then
      echo -e "\e[31;1m[WARNING]\e[37;0m Environment variable ${env_var} not set!\e[0m"
      echo "Defaulting ${var} to ${!var}"
    else
      echo "Detected Environment variable, setting ${var} to ${env_var}"
      declare "${var}"="${!env_var}"
    fi
  done
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then  # user requested help
  echo -e "Usage: $0 [OPTION] [ADDRESS]"
  echo -e "Quickly change MAC Address of device (current device: ${DEVICE_NAME})"
  echo -e ""
  echo -e "  -h, --help   \tShow this help message"
  echo -e "  -y, --yes    \tAutomatically respond 'yes' to all queries"
  echo -e ""
  echo -e "Options for ADDRESS:"
  echo -e "  XX           \t\t2 Chars as end of MAC Address"
  echo -e "  XX:XX:XX:XX:XX \t17 Chars as complete MAC Address"
  echo -e "               \t\tSwitch between two saved Addresses"
  exit 0
fi

init_vars
get_current_mac
echo "Current MAC Address: ${CURRENT_MAC}"

LENGTH=${#1}
change_mac "${1}" ${LENGTH}

if [ $? -ne 0 ] || [ -z "${MAC_ADDRESS}" ]; then
  echo "Something went terribly wrong!"
  exit 2  # should never occur
fi

echo "Changing MAC to ${MAC_ADDRESS}"
if [ "$1" = "-y" ] || [ "$1" = "--yes" ]; then
  ANSWER="Y"
fi
while [ "$ANSWER" != "Y" ] && [ "$ANSWER" != "n" ];
do
  echo -n "Continue? (Y/n) "
  read ANSWER
done
if [ "$ANSWER" != "Y" ];then
  echo "Abort"
  exit 5
fi

sudo ip link set dev ${DEVICE_NAME} down
sudo ip link set dev ${DEVICE_NAME} address ${MAC_ADDRESS}
sudo ip link set dev ${DEVICE_NAME} up

echo "Updated MAC Address"
get_current_mac
echo "New MAC Address: ${CURRENT_MAC}"
