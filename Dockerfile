# Start with base Docker image
FROM node:18
WORKDIR /usr/src/app

# Copy the entire app to the container
COPY . .

# Install all dependencies and build the app
RUN npm install && npm run build

# Start the app 
EXPOSE 8080
CMD ["npm", "start"]