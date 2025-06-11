#!/bin/sh
curl https://mise.jdx.dev/install.sh | sh
~/.local/bin/mise install

cd ..

~/.local/bin/mise x -- tuist clean
~/.local/bin/mise x -- tuist generate --no-open
