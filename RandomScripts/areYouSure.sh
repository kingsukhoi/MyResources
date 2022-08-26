#!/bin/bash
set -ueo pipefail

read -p "Are you sure. [y/N]: " key
if [[ "$key" = y ]]; then
  echo "do action"
else
  echo "don't do"
fi


