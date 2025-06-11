#!/bin/sh
set -e

curl -s https://mise.jdx.dev/install.sh | bash
export PATH="$HOME/.local/bin:$PATH"

eval "$(mise activate bash)"

mise install

cd ..
tuist clean
tuist generate --no-open
