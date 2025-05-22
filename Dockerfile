FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Set working directory
WORKDIR /app

# Copy Poetry configuration files
COPY pyproject.toml poetry.lock ./

# Copy README.md
COPY README.md ./

# Configure Poetry
RUN /root/.local/bin/poetry config virtualenvs.create false

# Install dependencies
RUN /root/.local/bin/poetry install --only main --no-root

# Copy the rest of the application
COPY . .

CMD ["sleep", "infinity"]