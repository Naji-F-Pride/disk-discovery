#!/bin/bash

ssd=()
hdd=()
nvme=()
all=$(lsblk -lnpdb -I 8,259 -x SIZE -o NAME,ROTA)

while read path rotating
do
    mountpoint=$(lsblk -ln -o MOUNTPOINT $path)
    
    if [[ -n $mountpoint ]]
    then
        continue
    elif [[ $rotating == 1 ]]
    then
        hdd+=("$path")
    elif [[ $path =~ "sd" ]]
    then
        ssd+=("$path")
    elif [[ $path =~ "nvme" ]]
    then
        nvme+=($path)
    fi
done <<< $all

iter=0
for disk in ${ssd[@]}
do
    ln -s $disk "/dev/ssd-${iter}"
    ((++iter))
done

iter=0
for disk in ${hdd[@]}
do
    ln -s $disk "/dev/hdd-${iter}"
    ((++iter))
done

iter=0
for disk in ${nvme[@]}
do
    ln -s $disk "/dev/nvme-${iter}"
    ((++iter))
done
