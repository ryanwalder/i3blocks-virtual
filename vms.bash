#!/usr/bin/env bash

function is_installed() {
    if hash $1 &>/dev/null; then
        return 0
    else
        return 1
    fi
}

unset vmware
unset virtualbox
unset lxc
unset docker

if is_installed vmrun; then
    vmware=$(vmrun list | head -n1 | rev | awk {'print $1'})
    if [[ $vmware != 0 ]]; then
        vmware="VMW: $vmware"
    else
        unset vmware
    fi
fi

if is_installed vboxmanage; then
    vbox=$(vboxmanage list runningvms | wc -l)
    if [[ $vbox != 0 ]]; then
        vbox="VBOX: $vbox"
    else
        unset vbox
    fi
fi

# Requires sudo to run
if is_installed lxc-ls; then
    lxc=$(sudo lxc-ls --active --fancy | grep -v NAME | wc -l)
    if [[ $lxc != 0 ]]; then
        lxc="LXC: $lxc"
    else
        unset lxc
    fi
fi

# Your user needs to be added to the docker group
if is_installed docker; then
    docker=$(docker ps | sed -n '1!p' | wc -l)
    if [[ $docker != 0 ]]; then
        docker="DKR: $docker"
    else
        unset docker
    fi
fi

echo "$vmware $vbox $lxc $docker" | sed s/\ \ //g | sed s/^\ //
