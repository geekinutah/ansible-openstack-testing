#!/usr/bin/env bash

# Check to make sure OpenStack credentials are set
if [ -z "$OS_PROJECT_ID" ]; then
    echo "Please make sure OpenStack credentials are loaded into the environment"
    echo "You can generally get OpenStack credentials from Horizon. The generic "
    echo "way to load these is: . ./openrc . Replace openrc with whatever file  "
    echo "holds your credentials."
    exit 1
fi

# Check for ssh-agent keys
if [[ "The agent has no identities." == `ssh-add -L | sed 's/\n//g'` ]]; then
    echo "You have no identities in your ssh-agent. Please add the appropriate  "
    echo "keys as the automation relies heavily upon them. This will generally  "
    echo "your default key in OpenStack."
    exit 1
fi

# Check for python3
if [ -z `which python3` ]; then
    echo "This process requires installation of Python3. Please remedy."
    exit 1
fi

# Check and see if .ssh/config.d exists and is included

if [ ! -d ~/.ssh/config.d ]; then
    echo "I noticed that .ssh/config.d doesn't exist. This will make your life "
    echo "harder as you attempt to work in this environment. As part of the    "
    echo "installation process we create ssh aliases so you don't have to      "
    echo "remember IP addresses."

    echo "Please do the following:"
    echo "   mkdir -p ~/.ssh/config.d/"
    echo ""
    echo "Then edit your .ssh/config so that this line is at the very top:"
    echo "   Include ~/.ssh/config.d/*"
    echo ""
    echo "You can also use the following command:"
    echo "   sed -i '1s/^/Include ~\/.ssh\/config.d\/*/' ~/.ssh/config"
fi
