#!/usr/bin/env bash

# Exit on error
set -e

# Install dependencies
apt-get update
apt-get install -y wget unzip apt-transport-https ca-certificates software-properties-common

# Install Google Chrome
echo "Installing Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt-get install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# Install ChromeDriver
echo "Installing ChromeDriver..."
CHROME_VERSION=$(google-chrome --version | grep -oP '\d+' | head -1)
CHROMEDRIVER_VERSION=$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_VERSION})
wget https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip
unzip chromedriver_linux64.zip -d /usr/local/bin/
chmod +x /usr/local/bin/chromedriver
rm chromedriver_linux64.zip

# Print versions for debugging
echo "Google Chrome version: $(google-chrome --version)"
echo "ChromeDriver version: $(chromedriver --version)"

# Install Node.js dependencies
echo "Installing Node.js dependencies..."
npm install
