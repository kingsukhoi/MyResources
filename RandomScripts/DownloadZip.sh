#!/bin/bash
set -ue

wget -qO- wget -qO- "$1" | bsdtar -xvf .
