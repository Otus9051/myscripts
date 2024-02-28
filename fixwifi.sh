#!/bin/bash
echo "Otus9051's Fix Wifi Script"

# This script was made due to a very peculiar issue with the automatic metric system which stopped me from using an AP acting as almost a dumb switch

echo "------------------------------------------------------"
echo "Route Table"
echo "------------------------------------------------------"
echo ""
sudo route -4
echo ""

echo "------------------------------------------------------"
echo "IP Addresses"
echo "------------------------------------------------------"
echo ""
sudo ip a
echo ""

echo "------------------------------------------------------"
echo "Setting up routes"
echo "------------------------------------------------------"

echo "Delete Default Route"; 
sudo ip r d default dev wlo1

sleep 1
echo "Delete 10.0.0.0/8 Route 1"; 
sudo ip r d 10.0.0.0/8 dev wlo1

sleep 1
echo "Delete 10.0.0.0/8 Route 2"; 
sudo ip r d 10.0.0.0/8 dev wlo1

sleep 1
echo "Add main route without metric"; 
sudo ip r a 10.0.0.0/8 dev wlo1 proto kernel scope link src 10.0.0.10

sleep 1
echo "Add Default Route"; 
sudo ip r a default via 10.0.0.1

echo ""
echo "------------------------------------------------------"
echo "Done! Showing Routes."
echo "------------------------------------------------------" 
echo ""
sudo route -4

echo ""
echo "------------------------------------------------------"
echo "Pinging 1.1.1.1"
echo "------------------------------------------------------" 
echo ""
ping 1.1.1.1 -c 1

echo ""
echo "------------------------------------------------------"
echo "Checking DNS"
echo "------------------------------------------------------" 
echo ""
dig TXT whoami.ds.akahelp.net | grep "IN"