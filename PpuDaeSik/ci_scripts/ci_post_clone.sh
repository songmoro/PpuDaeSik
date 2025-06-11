#!/bin/sh
curl https://mise.jdx.dev/install.sh | sh
eval "$(~/.local/bin/mise activate zsh)"

mise install tuist
mise --version
mise x -- tuist version

cd ..

mise x -- tuist clean
mise x -- tuist generate --no-open
