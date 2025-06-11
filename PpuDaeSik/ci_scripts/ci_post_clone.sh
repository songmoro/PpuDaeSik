#!/bin/sh
curl https://mise.jdx.dev/install.sh | sh
eval "$(~/.local/bin/mise activate zsh)"

mise install tuist
mise --version
tuist version

cd ..

tuist clean
tuist generate --no-open
