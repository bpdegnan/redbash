#!/usr/bin/env bash
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
    TAR_FILE=$(ls *.tar.gz *.tgz 2>/dev/null | head -n 1)
    if [ -z "$TAR_FILE" ]; then
        echo "Error: No tar file found."
        exit 1
    fi
    tar zxvf $TAR_FILE
    if [[ "$TAR_FILE" == *.tar.gz ]]; then
       DIR_NAME=$(basename "$TAR_FILE" .tar.gz)
    elif [[ "$TAR_FILE" == *.tgz ]]; then
        DIR_NAME=$(basename "$TAR_FILE" .tgz)
    else
    echo "Unsupported file format. Only .tar.gz and .tgz are supported."
        exit 1
    fi
    cd "$DIR_NAME"
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
    TAR_FILE=$(ls *.tar.gz *.tgz 2>/dev/null | head -n 1)
    if [ -z "$TAR_FILE" ]; then
        echo "Error: No tar file found."
        exit 1
    fi
    tar zxvf $TAR_FILE
    if [[ "$TAR_FILE" == *.tar.gz ]]; then
       DIR_NAME=$(basename "$TAR_FILE" .tar.gz)
    elif [[ "$TAR_FILE" == *.tgz ]]; then
        DIR_NAME=$(basename "$TAR_FILE" .tgz)
    else
    echo "Unsupported file format. Only .tar.gz and .tgz are supported."
        exit 1
    fi
    cd "$DIR_NAME"
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
    TAR_FILE=$(ls *.tar.gz *.tgz 2>/dev/null | head -n 1)
    if [ -z "$TAR_FILE" ]; then
        echo "Error: No tar file found."
        exit 1
    fi
    tar zxvf $TAR_FILE
    if [[ "$TAR_FILE" == *.tar.gz ]]; then
       DIR_NAME=$(basename "$TAR_FILE" .tar.gz)
    elif [[ "$TAR_FILE" == *.tgz ]]; then
        DIR_NAME=$(basename "$TAR_FILE" .tgz)
    else
    echo "Unsupported file format. Only .tar.gz and .tgz are supported."
        exit 1
    fi
    cd "$DIR_NAME"
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
    TAR_FILE=$(ls *.tar.gz *.tgz 2>/dev/null | head -n 1)
    if [ -z "$TAR_FILE" ]; then
        echo "Error: No tar file found."
        exit 1
    fi
    tar zxvf $TAR_FILE
    if [[ "$TAR_FILE" == *.tar.gz ]]; then
       DIR_NAME=$(basename "$TAR_FILE" .tar.gz)
    elif [[ "$TAR_FILE" == *.tgz ]]; then
        DIR_NAME=$(basename "$TAR_FILE" .tgz)
    else
    echo "Unsupported file format. Only .tar.gz and .tgz are supported."
        exit 1
    fi
    cd "$DIR_NAME"    
    
    ./autogen.sh
    ./configure --prefix=$PRIVATE_DIR
    make
    if [ $? -ne 0 ]; then
        echo "Error: make mtree failed. "
        exit 1
    fi
    make install
fi


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
    if [[ "$TAR_FILE" == *.tar.gz ]]; then
       DIR_NAME=$(basename "$TAR_FILE" .tar.gz)
    elif [[ "$TAR_FILE" == *.tgz ]]; then
        DIR_NAME=$(basename "$TAR_FILE" .tgz)
    else
    echo "Unsupported file format. Only .tar.gz and .tgz are supported."
        exit 1
    fi
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
    if [[ "$TAR_FILE" == *.tar.gz ]]; then
       DIR_NAME=$(basename "$TAR_FILE" .tar.gz)
    elif [[ "$TAR_FILE" == *.tgz ]]; then
        DIR_NAME=$(basename "$TAR_FILE" .tgz)
    else
    echo "Unsupported file format. Only .tar.gz and .tgz are supported."
        exit 1
    fi
    cd "$DIR_NAME"
    #don't know why it didn't work with theprefix 
    CPPFLAGS="-I/$PRIVATE_DIR/usr/local/include/bearssl"  ./configure --with-bearssl=$PRIVATE_DIR/usr/local --prefix=$PRIVATE_DIR/usr/local

    make
    if [ $? -ne 0 ]; then
        echo "Error: make $TAR_FILE failed."
        exit 1
    fi
    make install

fi

#see if we already built libcrypto.a for macports.  If not, we run the code
if [[ ! -f "$PRIVATE_DIR/usr/local/libs/libcrypto.a" && ! -f "$PRIVATE_DIR/usr/local/libs64/libcrypto.a" ]]; then
    cd $SCRIPT_DIR/src/openssl
    TAR_FILE=$(ls *.tar.gz *.tgz 2>/dev/null | head -n 1)
    if [ -z "$TAR_FILE" ]; then
        echo "Error: No tar file found."
        exit 1
    fi
    tar zxvf $TAR_FILE
    if [[ "$TAR_FILE" == *.tar.gz ]]; then
       DIR_NAME=$(basename "$TAR_FILE" .tar.gz)
    elif [[ "$TAR_FILE" == *.tgz ]]; then
        DIR_NAME=$(basename "$TAR_FILE" .tgz)
    else
    echo "Unsupported file format. Only .tar.gz and .tgz are supported."
        exit 1
    fi
    cd "$DIR_NAME"    
    
    ./Configure no-shared --prefix=$PRIVATE_DIR/usr/local
    make
    if [ $? -ne 0 ]; then
        echo "Error: make $TAR_FILE failed. "
        exit 1
    fi
    make install
fi


#bsdsed is a port that I did to support strict BSD compatibility
if command -v bsdsed >/dev/null 2>&1; then
    echo "bsdsed found"
else
    echo "bsdsed is not installed"
    cd $SCRIPT_DIR/src/
    git clone https://github.com/bpdegnan/bsdsed.git
    cd $SCRIPT_DIR/src/bsdsed   
    ./autogen.sh
    ./configure --prefix=$PRIVATE_DIR
    make
    if [ $? -ne 0 ]; then
        echo "Error: make bsdsed failed. "
        exit 1
    fi
    make install
fi


#now on to macports

cd $PRIVATE_TMP
if [ -d "macports-base" ]; then
  echo "Directory macports-base already exists. Skipping git clone."
  cd macports-base
  git fetch  # Update remote refs
  git checkout v2.10.2
else
  git clone https://github.com/macports/macports-base.git
  cd macports-base
  git checkout v2.10.2
fi



# Run configure and check its exit status
CFLAGS="-I/$PRIVATE_DIR/usr/local/include -I/$PRIVATE_DIR/usr/local/include/curl" LDFLAGS="-L/$PRIVATE_DIR/usr/local/lib -L/$PRIVATE_DIR/usr/local/lib64" ./configure --prefix=$PRIVATE_MACPORTS --without-startupitems
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
#the user needs an overide so it doesn't try it as root
make install DSTUSR=$(whoami) DSTGRP=$(id -gn) DSTMODE=0755 
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
