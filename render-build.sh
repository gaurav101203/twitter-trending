#!/bin/bash

# Install dependencies
apt-get update && apt-get install -y wget unzip

# Download Chromium
echo "Downloading Chromium..."
wget https://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux_x64/123456/chrome-linux.zip
unzip chrome-linux.zip -d /usr/local/bin/chrome
rm chrome-linux.zip

# Add Chrome to PATH
export PATH=$PATH:/usr/local/bin/chrome

# Download ChromeDriver
echo "Downloading ChromeDriver..."
wget https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip
unzip chromedriver_linux64.zip -d /usr/local/bin/
rm chromedriver_linux64.zip

# Set proper permissions
chmod +x /usr/local/bin/chromedriver

# Add ChromeDriver to PATH
export PATH=$PATH:/usr/local/bin/

# Install Node.js dependencies
npm install
