# Use the official Node.js image
FROM node:14

# Create and change to the app directory
WORKDIR /usr/src/app

# Copy the app source code to the container
COPY . .

# Install dependencies
RUN npm install

# Expose the port
EXPOSE 8080

# Start the application
CMD ["node", "app.js"]
