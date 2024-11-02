# Use an official Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        libsdl1.2-dev \
        git \
        vim \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /opt/ti99sim

# Copy the local repo
COPY . /opt/ti99sim/

# Build the project
RUN make && make install

# Entrypoint
COPY ./entrypoint.sh /

# Set the entry point to the built executable
SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/entrypoint.sh"]
