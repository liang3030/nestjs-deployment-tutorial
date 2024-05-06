# Use the official Node.js 18 image as a parent image
FROM node:20-alpine

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the yarn v4 installation file and install yarn globally
COPY .yarn .yarn
COPY .pnp.cjs .pnp.loader.mjs yarn.lock ./
RUN yarn set version 4.1.1


# Install the NestJS CLI tool
RUN yarn add @nestjs/cli --dev


# Copy the remaining application source code
COPY . .

# Install dependencies
# The --immutable option is similar to --frozen-lockfile in earlier versions of Yarn
RUN yarn install 

# Build the application if needed (uncomment if your app needs a build step)
RUN yarn build

# Expose the port the app runs on
# EXPOSE 3000

# Set environment variables

# Command to run the application
CMD ["yarn", "start:prod"]
