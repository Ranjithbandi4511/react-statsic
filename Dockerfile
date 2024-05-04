# Step 1: Build the React App
FROM node:16-alpine AS builder  # Using a lightweight Node.js base image
WORKDIR /app  # Setting the working directory in the container

# Copy package.json and install dependencies
COPY package.json package-lock.json .  # Copy package files
RUN npm install  # Install dependencies

# Copy the rest of the source code and build the React app
COPY . .
RUN npm run build  # Build the React app

# Step 2: Create the Final Docker Image
FROM nginx:alpine  # Use Nginx to serve the built React app
WORKDIR /usr/share/nginx/html  # Default directory for serving files with Nginx

# Remove existing Nginx files and copy the build output from the builder stage
RUN rm -rf ./*  # Clean the Nginx directory
COPY --from=builder /app/build .  # Copy build artifacts from the builder stage

# Expose port 80 for HTTP traffic
EXPOSE 80

# Set the command to keep Nginx running
ENTRYPOINT ["nginx", "-g", "daemon off;"]
