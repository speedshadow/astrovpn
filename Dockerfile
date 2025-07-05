# Stage 1: Build the application
# This stage installs dependencies and runs the build script
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the Astro application
RUN npm run build

# Stage 2: Create the final production image
# This stage takes only the necessary artifacts from the builder stage
FROM node:18-alpine

WORKDIR /app

# Copy built assets from the builder stage
COPY --from=builder /app/dist ./dist

# Copy production dependencies
COPY --from=builder /app/node_modules ./node_modules

# Copy package.json to be able to run npm start
COPY --from=builder /app/package.json ./

# Expose the port the application will run on
EXPOSE 4322

# The command to start the application
# This will execute the 'start' script defined in your package.json
CMD ["npm", "run", "start"]
