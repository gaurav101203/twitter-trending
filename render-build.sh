#!/usr/bin/env bash

# Exit on error
set -e

# Install dependencies
apt-get update
apt-get install -y wget unzip apt-transport-https ca-certificates software-properties-common
apt-get install -y libnss3 libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 libxi6 libxtst6 libxrandr2 libasound2 fonts-liberation

#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
# set -e

# Install Chrome
echo "Installing Chrome..."
mkdir -p /opt/chrome
curl -o /opt/chrome/chrome-linux64.zip https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.204/linux64/chrome-linux64.zip
unzip /opt/chrome/chrome-linux64.zip -d /opt/chrome/
rm /opt/chrome/chrome-linux64.zip

# Set environment variables for Chrome and ChromeDriver
export GOOGLE_CHROME_BIN="/opt/chrome/chrome-linux64/chrome"
export CHROMEDRIVER_PATH="/opt/chrome/chrome-linux64/chromedriver"

# Add Chrome binary to PATH
echo "Adding Chrome to PATH..."
export PATH=$PATH:/opt/chrome/chrome-linux64/

# Confirm installation
echo "Chrome binary is at: $GOOGLE_CHROME_BIN"
echo "ChromeDriver is at: $CHROMEDRIVER_PATH"

# Grant execution permissions
chmod +x $GOOGLE_CHROME_BIN
chmod +x $CHROMEDRIVER_PATH

# Install dependencies
echo "Installing Node.js dependencies..."
npm install

echo "Build script completed successfully."


# # Install ChromeDriver
# echo "Installing ChromeDriver..."
# CHROME_VERSION=$(google-chrome --version | grep -oP '\d+' | head -1)
# CHROMEDRIVER_VERSION=$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_VERSION})
# wget https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip
# unzip chromedriver_linux64.zip -d /usr/local/bin/
# chmod +x /usr/local/bin/chromedriver
# rm chromedriver_linux64.zip

# # Print versions for debugging
# echo "Google Chrome version: $(google-chrome --version)"
# echo "ChromeDriver version: $(chromedriver --version)"

# # Install Node.js dependencies
# echo "Installing Node.js dependencies..."
# npm install
