#!/bin/bash

## blocks ip addresses from list Due port, login, pass scans
#
while IFS= read -r ip
do
    sudo ufw insert 1 deny from "$ip" comment "Blocked due port, login, pass scans"
done < "block.list"
