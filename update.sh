#!/bin/bash
echo "Updating..."
sudo apt-get update
sudo apt-get upgrade
git pull
docker compose build
docker compose down
docker compose up -d
echo "Done!"