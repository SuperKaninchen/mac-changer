# mac-changer
## A small BASH script to easily change your MAC Address
**ONLY TESTED ON UBUNTU 18.04 (BIONIC BEAVER)**
### How to install:
1. Download the file "change_mac.sh"
1. (Optional) Set environment variables:
   * Set `MC_DEVICE_NAME` to the name of the device
   * Set `MC_OPTION_ONE` to the first MAC Address (for quick switch)
   * Set `MC_OPTION_TWO` to the second MAC Address (for quick switch)
1. (Optional) Test using `./change_mac.sh --help`
1. #### Done!

### How to use:
There are multiple options when using this script which can be specified with the use of command-line arguments.
If you run `./mac_changer.sh --help` you should see this screen:
```
Usage: ./change_mac.sh [OPTION] [ADDRESS]
Quickly change MAC Address of device (current device: wlp16s0)

  -h, --help   	Show this help message
  -y, --yes    	Automatically respond 'yes' to all queries

Options for ADDRESS:
  XX           		2 Chars as end of MAC Address
  XX:XX:XX:XX:XX 	17 Chars as complete MAC Address
               		Switch between two saved Addresses
```
#### Here are more detailed explanations:
Option | Explanation
-------|------------
-h, --help | Shows the help screen as shown above
-y, --yes | Will automatically respond with 'Y' if the script asks for user input

#### And here are the options for ADDRESS:
Input | Explanation
------|-------------
XX | Two chars which will be the new end of the MAC Adress, leaving the rest unchanged (eg. `3C`)
XX:XX:XX:XX:XX | 17 Chars seperated by colons which will be the new MAC Address
   | No chars will cause the script to check if the current MAC Address is one of the options, and change it
