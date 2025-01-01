#!/usr/bin/env bash
# Update and install dependencies
apt-get update
apt-get install -y wget unzip ca-certificates fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 libatk1.0-0 libcups2 libdrm2 libgbm1 libnspr4 libnss3 libx11-xcb1 libxcomposite1 libxdamage1 libxrandr2 xdg-utils

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt-get update
apt-get install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb


# Install ChromeDriver
CHROME_VERSION=$(google-chrome --version | grep -oP '\d+' | head -1)
wget https://chromedriver.storage.googleapis.com/$CHROME_VERSION/chromedriver_linux64.zip
unzip chromedriver_linux64.zip -d /usr/local/bin
chmod +x /usr/local/bin/chromedriver
rm chromedriver_linux64.zip


# Verify installation
if [ -f /usr/bin/google-chrome ]; then
  echo "Google Chrome is present at /usr/bin/google-chrome"
else
  echo "Google Chrome is NOT present at /usr/bin/google-chrome"
  exit 1
fi

if [ -f /usr/local/bin/chromedriver ]; then
  echo "ChromeDriver is present at /usr/local/bin/chromedriver"
else
  echo "ChromeDriver is NOT present at /usr/local/bin/chromedriver"
  exit 1
fi
