# Inception

This project consists in having you set up a small infrastructure composed of different
services under specific rules. The whole project has to be done in a virtual machine. You
have to use docker-compose.
Each Docker image must have the same name as its corresponding service.


Each service has to run in a dedicated container.
For performance matters, the containers must be built either from the penultimate stable
version of Alpine Linux, or from Debian Buster. The choice is yours.
You also have to write your own Dockerfiles, one per service. The Dockerfiles must
be called in your docker-compose.yml by your Makefile.
It means you have to build yourself the Docker images of your project. It is then forbidden to pull ready-made Docker images, as well as using services such as DockerHub
(Alpine/Debian being excluded from this rule).


You then have to set up:

• A Docker container that contains NGINX with TLSv1.2 or TLSv1.3 only.

• A Docker container that contains WordPress + php-fpm (it must be installed and
configured) only without nginx.

• A Docker container that contains MariaDB only without nginx.

• A volume that contains your WordPress database.

• A second volume that contains your WordPress website files.

• A docker-network that establishes the connection between your containers.
Your containers have to restart in case of a crash.

# Definitions
## What is a docker ?
Docker is a platform and set of tools that enable the development, deployment, and management of applications within containers. Containers are lightweight, portable, and isolated environments that package applications and their dependencies, allowing them to run consistently across different environments, such as development machines, testing servers, and production servers.

Here are key aspects and concepts related to Docker:

### Containerization: ### 
Docker uses containerization technology to create containers. A container is a standalone and executable package that includes everything needed to run a piece of software, including the code, runtime, libraries, and system tools. Containers isolate applications from the host system and other containers, ensuring consistency and reducing conflicts.

### Docker Engine: ###
Docker relies on a component called the Docker Engine, which consists of the Docker daemon (a background service) and a command-line interface (CLI) tool. The Docker CLI allows users to interact with Docker to build, run, and manage containers.

### Docker Images: ###
Docker images are read-only templates that define the contents and configuration of a container. Images serve as a blueprint for creating containers. They are typically based on a base operating system image (e.g., Alpine Linux or Debian) and can include application code and dependencies.

### Docker Containers: ###
Containers are instances of Docker images. When you run an image, it becomes a container. Containers are lightweight and start quickly. They are isolated from each other and from the host system, ensuring that changes made to one container do not affect others.

### Docker Compose: ###
Docker Compose is a tool for defining and running multi-container applications. It uses a YAML configuration file to specify the services, networks, and volumes required for an application. Compose simplifies the orchestration of complex applications made up of multiple containers.



## Installation

Just [Clone](git@github.com:Splix777/Inception.git) the repo. Change the user in the Makefile and compose-docker.yml to your local user and run make.


```bash
git@github.com:Splix777/Inception.git
```

## Usage

### General Useful commands ###

```c
- docker-compose up -d --build, //Create and build all the containers and they still run in the background
- docker-compose ps, //Check the status for all the containers
- docker-compose logs -f --tail 5, //See the first 5 lines of the logs of your containers
- docker-compose stop , //stop a stack of your docker compose
- Docker-compose down, //Destroy all your resources
- docker-compose config, //Check the syntax of you docker-compose file

```

### Docker run

```c
- docker run "name of the docker image" //Run the docker image
- docker run -d, //Run container in background
- docker run -p, //Publish a container's port to the host
- docker run -P, //Publish all exposed port to random ports
- docker run -it "imageName" bash //Run the Docker with access to the bash or (sh).
```

### Docker image
```c
- docker image rm -f "image name/id", //delete the image, if the image is running you need to kill it first.
- docker image kill "name", //stop a running image,
```
## The Basics of writting a dockerfile ##
- Create a file named 'dockerfile'.
- Write out the commands for your dockerfile.
- Below I describe a few of the commonly used ones:
  
  • FROM: Specifies the base image from which the new image is built. It's the starting point for your Docker image. For example, FROM ubuntu:20.04 sets the base image to Ubuntu 20.04.
  
  • LABEL: Adds metadata to the image in the form of key-value pairs. Labels are typically used for documentation and organization. For example, LABEL maintainer="John Doe <johndoe@example.com>".
  
  • RUN: Executes a command in the image during the build process. It's often used to install software or perform setup tasks. For example, RUN apt-get update && apt-get install -y curl.
  
  • COPY: Copies files or directories from the host system into the image. It's used to add application code and resources to the image. For example, COPY app.py /app/.
  
  • ADD: Similar to COPY, but has some additional features like unpacking compressed files and downloading files from URLs. Use it when you need more advanced copying behavior.
  
  • EXPOSE: Informs Docker that the container will listen on a specific port at runtime. It doesn't actually publish the port; it's for documentation purposes. For example, EXPOSE 80.
  
  • ENV: Sets environment variables that are available to processes running in the container. It's often used for configuration. For example, ENV DATABASE_URL=postgres://user:password@dbhost/database.
  
  • CMD: Specifies the default command to run when the container is started. It can be overridden at runtime. For example, CMD ["python", "app.py"].
  
  • ENTRYPOINT: Similar to CMD, but the command and its arguments are not easily overridden at runtime. It's used to define the main executable for the container. For example, ENTRYPOINT ["nginx", "-  g", "daemon off;"].
  
  • ARG: Defines a build-time variable that can be used in the Dockerfile. These variables are typically set with values when the Docker image is built using the --build-arg flag in the docker build command. ARGs provide a way to parameterize the Dockerfile and make it more flexible.
  

## Contributing

## License

[MIT](https://choosealicense.com/licenses/mit/)
