FROM node:24.0 AS builder

# Create app directory
WORKDIR /app

# Install app dependencies
COPY package*.json ./
RUN npm install
RUN npm install -g @nestjs/cli

COPY . .

# Build the app
RUN npm run build

FROM node:24.0-alpine AS runner

WORKDIR /app

# Copy the build from the builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# Install production dependencies
RUN npm install --omit=dev
RUN npm install -g @nestjs/cli

# Expose the port the app runs on
EXPOSE 5000

# Run the app
CMD ["npm", "run", "start:prod"]