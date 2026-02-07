# Use Python 3.11 slim image as base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install dependencies needed for DIE and the application
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    ca-certificates \
    libqt5core5a \
    libqt5svg5 \
    libqt5gui5 \
    libqt5widgets5 \
    libqt5opengl5 \
    libqt5dbus5 \
    libqt5scripttools5 \
    libqt5script5 \
    libqt5network5 \
    libqt5sql5 \
    && rm -rf /var/lib/apt/lists/*

# Install DIE (Detect-It-Easy) from GitHub releases
# Using version 3.10 for Debian 12 (compatible with Python 3.11-slim based on Debian Trixie)
RUN wget -q --show-progress https://github.com/horsicq/DIE-engine/releases/download/3.10/die_3.10_Debian_12_amd64.deb && \
    dpkg -i die_3.10_Debian_12_amd64.deb && \
    rm -f die_3.10_Debian_12_amd64.deb

# Copy requirements and setup files
COPY requirements.txt setup.py README.md ./
COPY karton ./karton

# Install Python dependencies and the package
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir .

# Set the entrypoint to the karton-die-classifier command
ENTRYPOINT ["karton-die-classifier"]
