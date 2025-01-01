#!/usr/bin/env bash
# Update and install dependencies
apt-get update
apt-get install -y wget unzip ca-certificates fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 libatk1.0-0 libcups2 libdrm2 libgbm1 libnspr4 libnss3 libx11-xcb1 libxcomposite1 libxdamage1 libxrandr2 xdg-utils

# Install Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb || apt-get -f install -y
if [ $? -ne 0 ]; then
  echo "Chrome installation failed"
  exit 1
else
  echo "Chrome installed successfully"
fi

# Install ChromeDriver
CHROME_VERSION=$(google-chrome --version | grep -oP '\d+\.\d+\.\d+\.\d+')
wget https://chromedriver.storage.googleapis.com/$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION)/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
chmod +x chromedriver
mv chromedriver /usr/local/bin/chromedriver
ln -s /usr/local/bin/chromedriver /usr/bin/chromedriver
if [ $? -ne 0 ]; then
  echo "Chromedriver installation failed"
  exit 1
else
  echo "Chromedriver installed successfully"
fi

# Verify installation
if [ -f /usr/local/bin/chromedriver ]; then
  echo "Chromedriver is present at /usr/local/bin/chromedriver"
else
  echo "Chromedriver is NOT present at /usr/local/bin/chromedriver"
  exit 1
fi

if [ -f /usr/bin/google-chrome ]; then
  echo "Google Chrome is present at /usr/bin/google-chrome"
else
  echo "Google Chrome is NOT present at /usr/bin/google-chrome"
  exit 1
fi
