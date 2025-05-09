# Use the official Node.js image as the base
FROM node:22

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json into the container
COPY package.json /app

# Install dependencies
RUN npm install

# Copy the rest of the application files into the container
COPY . /app

# Build the React application for production
RUN npm run build

# Use an official Nginx image to serve the static files
FROM nginx:alpine

# Copy the React build files to the Nginx web root
COPY --from=0 /app/build /usr/share/nginx/html

# Expose port 80 for the application
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]