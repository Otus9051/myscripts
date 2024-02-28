#!/bin/bash
echo "Otus9051's Fix Wifi Script"
# This script was made due to a very peculiar issue with the automatic metric system which stopped me from using an AP acting as almost a dumb switch
echo "------------------------------------------------------"
echo "route -4"
echo "------------------------------------------------------"
echo ""
sudo route -4
echo ""
echo "------------------------------------------------------"
echo "ip r"
echo "------------------------------------------------------"
echo ""
sudo ip r
echo ""
echo "------------------------------------------------------"
echo "ip a"
echo "------------------------------------------------------"
echo ""
sudo ip a
echo ""
echo "------------------------------------------------------"
echo "Setting up routes"
echo "------------------------------------------------------"
sudo ip a d 10.0.0.10/8 dev wlo1
sudo ip a a 10.0.0.10/8 dev wlo1 brd 10.255.255.255
sudo ip r a 10.0.0.0/8 dev wlo1 proto kernel scope link src 10.0.0.10
sudo ip r a default via 10.0.0.1
echo "------------------------------------------------------"
echo "Done!"
echo "------------------------------------------------------" 
sudo ip r
ping 1.1.1.1 -c 1