#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set the base directory (you can change this variable)
PRIVATE_DIR="$HOME/private"
PRIVATE_MACPORTS="$PRIVATE_DIR/opt"
# Create directories based on the PRIVATE_DIR variable
PRIVATE_TMP="$PRIVATE_DIR/var/tmp"
mkdir -p "$PRIVATE_TMP"


#now to go through things that might not be in the corporate linux



if command -v help2man >/dev/null 2>&1; then
    echo "help2man found"
else
    echo "help2man is not installed"
    cd $SCRIPT_DIR/src/help2man
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
        echo "Error: make help2man failed. "
        exit 1
    fi
    make install
fi


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
if [[ ! -f "$PRIVATE_DIR/usr/local/lib/libcrypto.a" && ! -f "$PRIVATE_DIR/usr/local/lib64/libcrypto.a" ]]; then
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
latesttagmacports=$(git ls-remote --tags https://github.com/macports/macports-base.git | awk -F/ '/\/v[0-9]+\.[0-9]+\.[0-9]+$/{print $NF}' | sort -V | tail -n1)
if [ -d "macports-base" ]; then
  echo "Directory macports-base already exists. Skipping git clone."
  cd macports-base
  git fetch  # Update remote refs
  if [[ -z "$latesttagmacports" ]]; then
    echo "No valid tag found. Staying on the current branch."
  else
    git checkout "$latesttagmacports"
  fi
else
  git clone https://github.com/macports/macports-base.git
  cd macports-base
  git fetch  # Update remote refs
  if [[ -z "$latesttagmacports" ]]; then
    echo "No valid tag found. Staying on the current branch."
  else
    git checkout "$latesttagmacports"
  fi
fi


# Run configure and check its exit status
CFLAGS="-I/$PRIVATE_DIR/usr/local/include -I/$PRIVATE_DIR/usr/local/include/curl" LDFLAGS="-L/$PRIVATE_DIR/usr/local/lib -L/$PRIVATE_DIR/usr/local/lib64" ./configure --with-no-root-privileges --prefix=$PRIVATE_MACPORTS --with-unsupported-prefix=$PRIVATE_MACPORTS --without-startupitems --with-mtree=$PRIVATE_DIR/bin/mtree --with-install-user=$USER --with-install-group=$USER --with-macports-user=$USER 
if [ $? -ne 0 ]; then
    echo "Error: configure failed. Please see the above for errors"
    exit 1
fi
#START PATCH FOR uname=root
#before the make, fix  uname=root gname=admin in a few files
#this is basically pasting in a different script I wrote.  This *sometimes* comes up
# as an issue
USER=$(whoami)
GROUP=$(groups | awk '{print $1}')
# Ensure we're starting in the correct directory
START_DIR=$(pwd)
# Navigate to the doc directory
if [ ! -d "doc" ]; then
  echo "doc directory not found. Exiting."
  exit 1
fi
cd doc || exit 1
# Files to modify
FILES=("base.mtree" "prefix.mtree")

# Loop through each file and perform the replacement
for FILE in "${FILES[@]}"; do
  if [ -f "$FILE" ]; then
    sed -i.bak "s/uname=root gname=admin/uname=$USER gname=$GROUP/g" "$FILE"
    echo "Updated $FILE. Backup created as $FILE.bak"
  else
    echo "File $FILE not found. Skipping."
  fi
done
# Return to the starting directory
cd "$START_DIR" || exit 1
#END PATCH FOR uname=root

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

# Update the macports.conf to not sanitize LD_LIBRARY_PATH
portconffile="$PRIVATE_MACPORTS/etc/macports/macports.conf"
if [[ -f "$portconffile" ]]; then
    sed -i '/^#extra_env/a\extra_env LD_LIBRARY_PATH LIBRARY_PATH' "$portconffile"
else
    echo "Error: File $portconffile does not exist."
    exit 1
fi



# Check which shell is being used
shell_config=""
if [ -n "$BASH_VERSION" ]; then
    shell_config="$HOME/.bashrc"
elif [ -n "$ZSH_VERSION" ]; then
    shell_config="$HOME/.zshrc"
fi

# Add $PRIVATE_MACPORTS/bin and $PRIVATE_MACPORTS/sbin to PATH if not already there
#if ! grep -q "export PATH=\"$PRIVATE_MACPORTS/bin:$PRIVATE_MACPORTS/sbin:\$PATH\"" "$shell_config"; then
#    echo "export PATH=\"$PRIVATE_MACPORTS/bin:$PRIVATE_MACPORTS/sbin:\$PATH\"" >> "$shell_config"
#    echo "Added $PRIVATE_MACPORTS/bin and $PRIVATE_MACPORTS/sbin to PATH in $shell_config"
#else
#    echo "$PRIVATE_MACPORTS/bin and $PRIVATE_MACPORTS/sbin are already in your PATH."
#fi

# Trying a smarter way.  I want to put macports paths first
# Add $PRIVATE_MACPORTS/bin and $PRIVATE_MACPORTS/sbin to PATH if not already there
if ! grep -q "export PATH=\"$PRIVATE_MACPORTS/bin:$PRIVATE_MACPORTS/sbin:\$PATH\"" "$shell_config"; then
    # Insert the line before the first PATH-related line or at the beginning if no PATH-related lines exist
    if grep -q "PATH=" "$shell_config"; then
        sed -i "/PATH=/i export PATH=\"$PRIVATE_MACPORTS/bin:$PRIVATE_MACPORTS/sbin:\$PATH\"" "$shell_config"
    else
        # No PATH-related lines found, append at the top
        sed -i "1i export PATH=\"$PRIVATE_MACPORTS/bin:$PRIVATE_MACPORTS/sbin:\$PATH\"" "$shell_config"
    fi
    echo "Added $PRIVATE_MACPORTS/bin and $PRIVATE_MACPORTS/sbin to PATH in $shell_config"
else
    echo "$PRIVATE_MACPORTS/bin and $PRIVATE_MACPORTS/sbin are already in your PATH."
fi

# Add $PRIVATE_MACPORTS/lib to LD_LIBRARY_PATH if not already there
#I have a few instances, I probably could figure out how to make a function
if ! grep -q "export LD_LIBRARY_PATH=\"$PRIVATE_MACPORTS/lib:\$LD_LIBRARY_PATH\"" "$shell_config"; then
    # Insert the line before the first LD_LIBRARY_PATH-related line or at the beginning if no such lines exist
    if grep -q "LD_LIBRARY_PATH=" "$shell_config"; then
        sed -i "/LD_LIBRARY_PATH=/i export LD_LIBRARY_PATH=\"$PRIVATE_MACPORTS/lib:\$LD_LIBRARY_PATH\"" "$shell_config"
    else
        # No LD_LIBRARY_PATH-related lines found, append at the top
        sed -i "1i export LD_LIBRARY_PATH=\"$PRIVATE_MACPORTS/lib:\$LD_LIBRARY_PATH\"" "$shell_config"
    fi
    echo "Added $PRIVATE_MACPORTS/lib to LD_LIBRARY_PATH in $shell_config"
else
    echo "$PRIVATE_MACPORTS/lib is already in your LD_LIBRARY_PATH."
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
