# This file configures the environment for Node.js development tools

# pnpm (Performant NPM) is an alternative to npm and yarn
# It's a fast, disk space efficient package manager for Node.js
# https://pnpm.io

# Set the PNPM_HOME directory where global packages will be installed
export PNPM_HOME="$HOME/Library/pnpm"

# Add PNPM_HOME to PATH, but only if it's not already there
# This pattern checks if PNPM_HOME is already in PATH before adding it
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
