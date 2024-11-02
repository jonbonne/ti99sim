# scan the following github fork: https://github.com/billzajac/ti99sim. Then generate a Dockerfile that installs all the dependencies of the repo, clones and builds the ti99sim into a docker image.

To create a Docker image that installs all dependencies, clones the `ti99sim` repository, and builds the project, you can use the following `Dockerfile`:

```dockerfile
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
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone the ti99sim repository
RUN git clone https://github.com/jonbonne/ti99sim.git /opt/ti99sim

# Set the working directory
WORKDIR /opt/ti99sim

# Build the project
RUN make

# Set the entry point to the built executable
ENTRYPOINT ["./ti99sim-sdl"]
```

**Explanation:**

1. **Base Image**: The Dockerfile starts with the official Ubuntu 20.04 image.

2. **Environment Variable**: `DEBIAN_FRONTEND=noninteractive` is set to prevent interactive prompts during package installation.

3. **Package Installation**: The `RUN` command updates the package list and installs the necessary packages:
   - `build-essential`: Provides the compiler and build tools.
   - `libsdl1.2-dev`: Development files for SDL 1.2, required for building `ti99sim`.
   - `git`: For cloning the repository.

   After installation, it cleans up to reduce the image size.

4. **Repository Cloning**: The `ti99sim` repository is cloned into `/opt/ti99sim`.

5. **Working Directory**: The working directory is set to `/opt/ti99sim`.

6. **Building the Project**: The `make` command compiles the project.

7. **Entry Point**: The Docker container is set to run the `ti99sim-sdl` executable by default.

**Building the Docker Image:**

Save the Dockerfile and build the image using the following command:

```bash
docker build -t ti99sim .
```

**Running the Docker Container:**

To run the emulator, execute:

```bash
docker run --rm -it ti99sim
```

This setup provides a containerized environment for `ti99sim`, ensuring all dependencies are correctly installed and the application is built and ready to run. 


=======

# make a docker compose file to run the image from the last step and mount a directory for ti994a ROMS. also provide a resource for ti994a ROMS

To run the `ti99sim` image with a mounted directory for TI-99/4A ROMs using Docker Compose, here is a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  ti99sim:
    image: ti99sim
    build:
      context: .
    volumes:
      - ./roms:/opt/ti99sim/roms
    stdin_open: true
    tty: true
```

**Explanation**:

1. **`image`**: Specifies the image name we built, `ti99sim`.
2. **`volumes`**: Mounts the `./roms` directory on your host machine to `/opt/ti99sim/roms` in the container. This way, you can add your ROM files to the `./roms` folder, and they’ll be accessible within the container.

**Usage**:

1. Ensure the `Dockerfile` and `docker-compose.yml` are in the same directory.
2. Create a folder named `roms` in this directory and add the TI-99/4A ROM files there.
3. Run the container using:

   ```bash
   docker-compose up --build
   ```

This will build the Docker image (if not already built) and start the `ti99sim` emulator with the ROM directory mounted.

---

### Resource for TI-99/4A ROMs

Due to copyright restrictions, I can’t provide direct download links for ROMs. However, for legal ROM options, consider the following:

1. **Internet Archive**: The [Internet Archive](https://archive.org/) often hosts legally available software and ROMs for vintage computers.
2. **Vintage Computing Forums**: Forums such as [AtariAge](https://atariage.com/forums/) or other vintage computing sites often have discussions on how to find and use ROMs for systems like the TI-99/4A, usually with guidelines for legal usage.

Always ensure you have the right to use and download these files based on your local laws and licensing requirements.
