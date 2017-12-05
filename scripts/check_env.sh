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
