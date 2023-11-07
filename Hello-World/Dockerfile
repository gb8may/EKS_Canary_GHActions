# Use the official Nginx base image
FROM nginx:latest

# Set a maintainer label for the image
LABEL maintainer="Mayara Gouveia gb8may@gmail.com"

# Copy the HTML file to the default Nginx web root
COPY hello-world.html /usr/share/nginx/html

# Expose port 80 for web traffic
EXPOSE 80

# Start the Nginx web server
CMD ["nginx", "-g", "daemon off;"]
