#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Install Chrome
echo "Installing Chrome..."
CHROME_DIR="/opt/chrome"
CHROME_URL="https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.204/linux64/chrome-linux64.zip"
CHROME_BIN="$CHROME_DIR/chrome-linux64/chrome"
CHROMEDRIVER_BIN="$CHROME_DIR/chrome-linux64/chromedriver"

# Create directory for Chrome
mkdir -p $CHROME_DIR

# Download and unzip Chrome
curl -o $CHROME_DIR/chrome-linux64.zip $CHROME_URL
unzip $CHROME_DIR/chrome-linux64.zip -d $CHROME_DIR/
rm $CHROME_DIR/chrome-linux64.zip

# Verify Chrome binary exists
if [ ! -f "$CHROME_BIN" ]; then
  echo "Error: Chrome binary not found at $CHROME_BIN"
  exit 1
fi

# Grant execution permissions
chmod +x $CHROME_BIN
chmod +x $CHROMEDRIVER_BIN

# Set environment variables for Chrome and ChromeDriver
export GOOGLE_CHROME_BIN="$CHROME_BIN"
export CHROMEDRIVER_PATH="$CHROMEDRIVER_BIN"

# Add Chrome to PATH
export PATH=$PATH:$CHROME_DIR/chrome-linux64/

# Confirm installation
echo "Chrome binary is at: $GOOGLE_CHROME_BIN"
echo "ChromeDriver is at: $CHROMEDRIVER_PATH"

# Install Node.js dependencies
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
