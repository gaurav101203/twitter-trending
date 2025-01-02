#!/usr/bin/env bash

# Update package list and install dependencies
apt-get update
apt-get install -y wget gnupg unzip

# Add Google's signing key
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -

# Set up Chrome repository
sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

# Install Google Chrome
apt-get update
apt-get install -y google-chrome-stable

# Download and install ChromeDriver
CHROME_DRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)
wget -N https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
mv chromedriver /usr/local/bin/chromedriver
rm chromedriver_linux64.zip

# Set environment variable for Chrome binary
export CHROME_BIN=/usr/bin/google-chrome
