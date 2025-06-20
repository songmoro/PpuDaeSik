#!/bin/sh
mkdir -p "$SECRETS_XCCONFIG_PATH"

cat > "$SECRETS_XCCONFIG_FILE" <<EOF
LOGGER_API_KEY=${SECRETS_XCCONFIG}
EOF

curl https://mise.jdx.dev/install.sh | sh
eval "$(~/.local/bin/mise activate zsh)"

mise install tuist@4.50.2

mise --version
mise ls
mise use --global tuist@4.50.2
mise x -- tuist version

cd ..

mise x -- tuist clean
mise x -- tuist generate --no-open
