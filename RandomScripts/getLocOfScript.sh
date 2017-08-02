#!/bin/bash
set -ue

readlink -f $0 | sed -r "s:^(/.*)/.*$:\1:"
