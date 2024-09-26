#!/bin/bash

# Set the base directory (you can change this variable)
PRIVATE_DIR="$HOME/private"

# Create directories based on the PRIVATE_DIR variable
mkdir -p "$PRIVATE_DIR/bin"
mkdir -p "$PRIVATE_DIR/var/work"

# Check which shell is being used
shell_config=""
if [ -n "$BASH_VERSION" ]; then
    shell_config="$HOME/.bashrc"
elif [ -n "$ZSH_VERSION" ]; then
    shell_config="$HOME/.zshrc"
fi

# Add $PRIVATE_DIR/bin to PATH at the beginning if it's not already there
if ! grep -q "export PATH=\"$PRIVATE_DIR/bin:\$PATH\"" "$shell_config"; then
    echo "export PATH=\"$PRIVATE_DIR/bin:\$PATH\"" >> "$shell_config"
    echo "Added $PRIVATE_DIR/bin to the beginning of PATH in $shell_config"
else
    echo "$PRIVATE_DIR/bin is already in your PATH."
fi

# Reload shell configuration file
if [ -n "$BASH_VERSION" ]; then
    source "$HOME/.bashrc"
elif [ -n "$ZSH_VERSION" ]; then
    source "$HOME/.zshrc"
fi

echo "Directories created and PATH updated."
