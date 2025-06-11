#!/bin/sh
curl https://mise.jdx.dev/install.sh | sh
mise install

cd ..

mise exec -- tuist generate --no-open
