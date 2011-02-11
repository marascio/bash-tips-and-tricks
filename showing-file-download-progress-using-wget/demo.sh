#!/usr/bin/env bash

download()
{
    local url=$1
    echo -n "    "
    wget --progress=dot $url 2>&1 | \
        grep --line-buffered "%" | \
        sed -u -e "s,\.,,g" | \
        awk '{printf("\b\b\b\b%4s", $2)}'
    echo -ne "\b\b\b\b"
    echo " DONE"
}

file="patch-2.6.37.gz"
echo -n "Downloading $file:"
download "http://www.kernel.org/pub/linux/kernel/v2.6/$file"
