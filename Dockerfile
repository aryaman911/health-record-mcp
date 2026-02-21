# Use the official Bun image
FROM oven/bun:latest

# Set the working directory
WORKDIR /app

# Copy package.json and bun.lock first (for layer caching)
COPY package.json bun.lock ./

# Install dependencies
RUN bun install --frozen-lockfile

# Copy all application source code
COPY src/ ./src/
COPY static/ ./static/
COPY scripts/ ./scripts/
COPY clientTypes.ts clientFhirUtils.ts ehretriever.ts ./
COPY config.*.json sample-config.json ./
COPY opener.html ./

# Create data directory for persistence
RUN mkdir -p ./data

# Render uses port 10000 by default
EXPOSE 10000

# Run the SSE server with Render config
CMD [ "bun", "run", "src/sse.ts", "--config", "./config.render.json" ]