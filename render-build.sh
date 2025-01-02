#!/usr/bin/env bash

# Exit on error
set -e

# Install dependencies
apt-get update
apt-get install -y wget unzip apt-transport-https ca-certificates software-properties-common
apt-get install -y libnss3 libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 libxi6 libxtst6 libxrandr2 libasound2 fonts-liberation

# Download and extract Chrome from the provided URL
wget -O chrome-linux64.zip https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.204/linux64/chrome-linux64.zip
unzip chrome-linux64.zip -d /opt/chrome
rm chrome-linux64.zip

# Make Chrome executable
chmod +x /opt/chrome/chrome-linux64/chrome

# Set environment variables for Chrome
export GOOGLE_CHROME_BIN="/opt/chrome/chrome-linux64/chrome"

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
