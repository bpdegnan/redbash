#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set the base directory (you can change this variable)
PRIVATE_DIR="$HOME/private"
PRIVATE_MACPORTS="$PRIVATE_DIR/opt"
# Create directories based on the PRIVATE_DIR variable
PRIVATE_TMP="$PRIVATE_DIR/var/tmp"
mkdir -p "$PRIVATE_TMP"


#now to go through things that might not be in the corporate linux




#I need m4 to make autoconf
if command -v m4 >/dev/null 2>&1; then
    echo "m4 found"
else
    echo "m4 is not installed, so installing m4"
    cd $SCRIPT_DIR/src/m4
    tar zxvf m4-1.4.19.tar.gz
    cd m4-1.4.19
    ./configure --prefix=$PRIVATE_DIR
    make
    if [ $? -ne 0 ]; then
        echo "Error: make m4 failed. "
        exit 1
    fi
    make install
fi

#I need autoconf to make automake
if command -v autoconf >/dev/null 2>&1; then
    echo "autoconf found"
else
    echo "autoconf is not installed, so installing autoconf"
    cd $SCRIPT_DIR/src/autoconf
    tar zxvf autoconf-2.71.tar.gz
    cd autoconf-2.71
    ./configure --prefix=$PRIVATE_DIR
    make
    if [ $? -ne 0 ]; then
        echo "Error: make autoconf failed. "
        exit 1
    fi
    make install
fi

#automake
if command -v aclocal >/dev/null 2>&1; then
    echo "alocal found"
else
    echo "aclocal is not installed, so installing automake"
    cd $SCRIPT_DIR/src/automake
    tar zxvf automake-1.16.5.tar.gz
    cd automake-1.16.5
    ./configure --prefix=$PRIVATE_DIR
    make
    if [ $? -ne 0 ]; then
        echo "Error: make automake failed. "
        exit 1
    fi
    make install
fi


if command -v mtree >/dev/null 2>&1; then
    echo "mtree found"
else
    echo "mtree is not installed"
    cd $SCRIPT_DIR/src/mtree
    ./autogen.sh
    ./configure --prefix=$PRIVATE_DIR
    make
    if [ $? -ne 0 ]; then
        echo "Error: make mtree failed. "
        exit 1
    fi
    make install
fi

curl-config

if command -v curl-config >/dev/null 2>&1; then
    echo "curl-config found"
else
    echo "curl-config is not installed, so installing curl"
    
    #first, get bear ssl
    cd $SCRIPT_DIR/src/bearssl
    TAR_FILE=$(ls *.tar.gz *.tgz 2>/dev/null | head -n 1)
    if [ -z "$TAR_FILE" ]; then
        echo "Error: No tar file found."
        exit 1
    fi
    tar zxvf $TAR_FILE
    DIR_NAME=$(basename "$TAR_FILE" .tar.gz)
    cd "$DIR_NAME"
    
    make
    if [ $? -ne 0 ]; then
        echo "Error: make $TAR_FILE failed."
        exit 1
    fi

    mkdir -p $PRIVATE_DIR/usr/local/include/bearssl
    mkdir -p $PRIVATE_DIR/usr/local/lib
    cp inc/*.h $PRIVATE_DIR/usr/local/include/bearssl
    cp build/libbearssl.a $PRIVATE_DIR/usr/local/lib

    #now curl
    cd $SCRIPT_DIR/src/curl
    TAR_FILE=$(ls *.tar.gz *.tgz 2>/dev/null | head -n 1)
    if [ -z "$TAR_FILE" ]; then
        echo "Error: No tar file found."
        exit 1
    fi
    tar zxvf $TAR_FILE
    DIR_NAME=$(basename "$TAR_FILE" .tar.gz)
    cd "$DIR_NAME"
    #don't know why it didn't work with theprefix 
    CPPFLAGS="-I/$PRIVATE_DIR/usr/local/include/bearssl"  ./configure --with-bearssl=$PRIVATE_DIR/usr/local --prefix=$PRIVATE_DIR/usr/local

    make
    if [ $? -ne 0 ]; then
        echo "Error: make $TAR_FILE failed."
        exit 1
    fi

fi

#now on to macports

cd $PRIVATE_TMP
git clone https://github.com/macports/macports-base.git
cd macports-base

# Run configure and check its exit status
./configure --prefix=$PRIVATE_MACPORTS 
if [ $? -ne 0 ]; then
    echo "Error: configure failed. Please see the above for errors"
    exit 1
fi

# Run make and check its exit status
make
if [ $? -ne 0 ]; then
    echo "Error: make failed. "
    exit 1
fi
make install
if [ $? -ne 0 ]; then
    echo "Error: make failed to install. "
    exit 1
fi


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
