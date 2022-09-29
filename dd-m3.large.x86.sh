#!/bin/bash

ssd=()
nvme=()
all=$(lsblk -lnpdb -I 8,259 -x SIZE -o NAME)

while read path
do
    mountpoint=$(lsblk -ln -o MOUNTPOINT $path)

    if [[ -n $mountpoint ]]
    then
        continue
    elif [[ $path =~ "nvme" ]]
    then
        nvme+=("$path")
    else
        ssd+=("$path")
    fi
done <<< $all

iter=0
for disk in ${ssd[@]}
do
    ln -s $disk "/dev/ssd-drive-$iter"
    ((++iter))
done

iter=0
for disk in ${nvme[@]}
do
    ln -s $disk "/dev/nvme-drive-$iter"
    ((++iter))
done
