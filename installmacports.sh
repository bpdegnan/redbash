#!/bin/bash

# Set the base directory (you can change this variable)
PRIVATE_DIR="$HOME/private"
PRIVATE_MACPORTS="$PRIVATE_DIR/opt"


# Create directories based on the PRIVATE_DIR variable
PRIVATE_TMP="$PRIVATE_DIR/var/tmp"
mkdir -p "$PRIVATE_TMP"
cd $PRIVATE_TMP
git clone https://github.com/macports/macports-base.git
cd macports-base
./configure --prefix=$PRIVATE_MACPORTS && make && make install


# Create directories based on the PRIVATE_MACPORTS variable
mkdir -p "$PRIVATE_MACPORTS/bin"
mkdir -p "$PRIVATE_MACPORTS/sbin"
mkdir -p "$PRIVATE_MACPORTS/share/man"

# Check which shell is being used
shell_config=""
if [ -n "$BASH_VERSION" ]; then
    shell_config="$HOME/.bashrc"
elif [ -n "$ZSH_VERSION" ]; then
    shell_config="$HOME/.zshrc"
fi

# Add $PRIVATE_MACPORTS/bin and $PRIVATE_MACPORTS/sbin to PATH if not already there
if ! grep -q "export PATH=\"$PRIVATE_MACPORTS/bin:$PRIVATE_MACPORTS/sbin:\$PATH\"" "$shell_config"; then
    echo "export PATH=\"$PRIVATE_MACPORTS/bin:$PRIVATE_MACPORTS/sbin:\$PATH\"" >> "$shell_config"
    echo "Added $PRIVATE_MACPORTS/bin and $PRIVATE_MACPORTS/sbin to PATH in $shell_config"
else
    echo "$PRIVATE_MACPORTS/bin and $PRIVATE_MACPORTS/sbin are already in your PATH."
fi

# Add $PRIVATE_MACPORTS/share/man to MANPATH if not already there
if ! grep -q "export MANPATH=\"$PRIVATE_MACPORTS/share/man:\$MANPATH\"" "$shell_config"; then
    echo "export MANPATH=\"$PRIVATE_MACPORTS/share/man:\$MANPATH\"" >> "$shell_config"
    echo "Added $PRIVATE_MACPORTS/share/man to MANPATH in $shell_config"
else
    echo "$PRIVATE_MACPORTS/share/man is already in your MANPATH."
fi

# Reload shell configuration file
if [ -n "$BASH_VERSION" ]; then
    source "$HOME/.bashrc"
elif [ -n "$ZSH_VERSION" ]; then
    source "$HOME/.zshrc"
fi
