#!/bin/zsh
set -euo pipefail

sudo -v
sudo /bin/sh -c "$(curl -fsSL https://static.palera.in/scripts/install.sh)"
