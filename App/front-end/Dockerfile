# Step 1: Build the application in a "base" stage
FROM node:22-alpine AS base

WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package.json /app
RUN npm install 

# Copy application files
COPY . /app

# Build the Next.js app
RUN npm run build

# Step 2: Create a production-ready image
# FROM base AS production
FROM base AS production
WORKDIR /prod
# Copy only the necessary files from the build stage
COPY --from=base /app/.next /prod/.next
COPY --from=base /app/public /prod/public
COPY --from=base /app/node_modules /prod/node_modules
COPY --from=base /app/package.json /prod
EXPOSE 3000
CMD ["npm", "start"]

# use this for react 
# # Use the official Node.js image as the base
# FROM node:22

# # Set the working directory in the container
# WORKDIR /app

# # Copy package.json and package-lock.json into the container
# COPY package.json /app

# # Install dependencies
# RUN npm install

# # Copy the rest of the application files into the container
# COPY . /app

# # Build the React application for production
# RUN npm run build

# # Use an official Nginx image to serve the static files
# FROM nginx:alpine

# # Copy the React build files to the Nginx web root
# COPY --from=0 /app/build /usr/share/nginx/html

# # Expose port 80 for the application
# EXPOSE 80

# # Start Nginx
# CMD ["nginx", "-g", "daemon off;"]