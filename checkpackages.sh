#!/usr/bin/env bash

# Function to determine which package manager is available
get_package_manager() {
    # Check if a command exists
    command_exists() {
        command -v "$1" >/dev/null 2>&1
    }

    # Check for each package manager and return its name
    if command_exists dnf; then
        echo "dnf"
    elif command_exists yum; then
        echo "yum"
    elif command_exists apt; then
        echo "apt"
    elif command_exists pacman; then
        echo "pacman"
    elif command_exists zypper; then
        echo "zypper"
    else
        echo "none"
    fi
}

# Check if a package is installed based on the package manager
check_package_installed() {
    package_manager=$1
    package=$2

    case $package_manager in
        dnf|yum)
            sudo $package_manager list installed "$package" >/dev/null 2>&1
            ;;
        apt)
            dpkg -l "$package" >/dev/null 2>&1
            ;;
        pacman)
            pacman -Qs "$package" >/dev/null 2>&1
            ;;
        zypper)
            zypper search --installed-only "$package" >/dev/null 2>&1
            ;;
        *)
            return 1  # If no package manager is found, return failure
            ;;
    esac

    if [ $? -eq 0 ]; then
        echo "$package is installed."
    else
        echo "$package is NOT installed."
    fi
}

# Main logic starts here

# Determine the package manager
package_manager=$(get_package_manager)

if [ "$package_manager" = "none" ]; then
    echo "No supported package manager found. Exiting..."
    exit 1
else
    echo "The available package manager is: $package_manager"
fi

# Check if the package list file exists
package_file="packages.txt"

if [ ! -f "$package_file" ]; then
    echo "Package list file ($package_file) not found. Exiting..."
    exit 1
fi

# Read the package list from the .txt file and check each package
while IFS= read -r package; do
    # Check each package
    check_package_installed "$package_manager" "$package"
done < "$package_file"
