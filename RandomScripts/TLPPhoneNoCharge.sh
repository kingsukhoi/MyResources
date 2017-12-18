#!/bin/bash
set -ue
#!copied from here https://www.reddit.com/r/archlinux/comments/2y4i5k/phone_not_charging_through_usb_connection/
echo USB_BLACKLIST="$1">>/etc/default/tlp

