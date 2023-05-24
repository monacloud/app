# Stage 1: Builder image used to build the app
FROM node:18
WORKDIR /usr/src/app

# Install required package
COPY package.json .
RUN npm install

COPY . .

# Build the server
RUN npm run build

# Start the app 
EXPOSE 8080
CMD ["npm", "start"]