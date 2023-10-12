<div id="top"></div>
<p align=center>
  <img alt="Project's primary language" src="https://img.shields.io/badge/Language-Docker-blue">
  <img alt="Project's focus" src="https://img.shields.io/badge/Focus-Containerized%20website-blue">
</p>

<!-- PROJECT LOGO -->
<br />
<div align="center" style="height:200px; margin-bottom:10%">
  <a>
    <img src="assets/docker_moby.png" alt="Docker logo">
  </a>
</div>

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

### Docker Network Types: ###

1. Bridge Network:
   - Description: Default network type in Docker. Allows containers to communicate with each other on the same host.
   - Use Case: Suitable for isolated container communication on a single host.

2. Host Network:
   - Description: Containers share the host's network stack directly.
   - Use Case: Useful when containers need full access to the host's network but may reduce isolation.

3. Overlay Network:
   - Description: Used for multi-host communication in a Docker Swarm cluster.
   - Use Case: Ideal for deploying containerized applications across multiple nodes in a Docker Swarm cluster.

4. Macvlan Network:
   - Description: Enables containers to have their own MAC addresses and appear as separate physical devices on the network.
   - Use Case: Useful when containers need direct access to external networks.

5. None Network:
   - Description: Containers are isolated from all external networks, including the host's network.
   - Use Case: Appropriate for scenarios where complete network isolation is needed.

6. Bridge Network with Custom Subnet:
   - Description: Similar to the default bridge network but with a custom subnet range and gateway.
   - Use Case: When you need more control over IP addressing and routing within the bridge network.

7. Overlay Network with Custom Driver:
   - Description: Extends overlay network capabilities with custom network drivers.
   - Use Case: Advanced networking scenarios requiring specific features not provided by the default overlay network.

8. VxLAN Network:
   - Description: Uses Virtual Extensible LAN (VxLAN) for communication across multiple hosts.
   - Use Case: Spanning container networks across multiple hosts.

9. Swarm Ingress Network:
   - Description: Used in Docker Swarm mode to expose services to the outside world.
   - Use Case: Essential for load balancing and routing external traffic to services in a Swarm cluster.

### The Purpose of Volumes: ###

Volumes in Docker are used to manage and store data separately from the container file system. They provide several benefits, including data persistence, data sharing between containers, and portability.

Here's a breakdown of your Docker Compose file and how volumes are used:

## MariaDB Container: ##

The mariadb service is defined to run a MariaDB container.
A volume named mariadb is defined to persist the MariaDB database data. This volume is used to store the database files, ensuring that data is retained even if the container is stopped or removed.
The volume is mounted at /var/lib/mysql in the MariaDB container, allowing the database to read and write data to this location.

## WordPress Container: ##

The wordpress service is defined to run a WordPress container.
A volume named wordpress is defined to persist WordPress application data. This volume is mounted at /var/www/html/wordpress in the WordPress container.
This allows WordPress to store and access its files, themes, plugins, and uploads independently of the container's file system.

## Nginx Container: ##

The nginx service is defined to run an Nginx web server container.
It uses the same wordpress volume as the WordPress container, allowing Nginx to serve the WordPress site's files from the same shared volume.
The purpose of using volumes in this setup:

### Benefits of Using Volumes: ###

## Data Persistence: ##

Volumes ensure that important data, such as the MariaDB database and WordPress files, persists across container restarts and updates. When containers are recreated or updated, data stored in volumes remains intact.

## Separation of Concerns: ##

By using volumes, you separate data from the container itself. This is important for maintaining data integrity and enabling easy container replacement or scaling.

## Data Sharing: ##

Multiple containers in the same Compose network can share the same volumes. In your case, both the WordPress and Nginx containers use the wordpress volume, enabling them to serve the same website files.

## Portability: ##

Using volumes makes it easier to move your Docker Compose setup to different environments or servers without worrying about data loss or corruption. You just need to ensure the volumes are mounted correctly on the new system.

In summary, volumes in Docker are a way to manage and persist data for containers. They offer data persistence, isolation, sharing, and portability, making them a crucial aspect of managing stateful applications like databases or content management systems in containerized environments.

### Different Types of Volumes: ###

## Named Volumes: ##

-Named volumes are the most commonly used type. They have a user-friendly name and are managed by Docker.

-They are created and named in Docker, making it easy to reference them in your Docker Compose files or CLI commands.

-You can create named volumes explicitly using docker volume create or let Docker create them implicitly when you reference a volume in your container configuration.

## Bind Mounts: ##

- Bind mounts allow you to mount a directory from the host system into a container.

- They are not managed by Docker and, as a result, have more control and flexibility.

- Bind mounts are useful for development or when you want to access specific files or directories from your host machine inside a container.

## TMPFS Mounts: ##

- TMPFS mounts are a special type of volume that resides in the host's memory.

- They are useful for situations where you need a very fast and temporary storage space. However, data stored in TMPFS volumes is lost when the container is removed or stopped.

#### HINT: ####

If your containers boot up and you are able to access WordPress through localhost and 127.0.0.1 but not your username.42.fr; you might need to modify your VM /etc/hosts file. Seeing how this project has to be done within a virtual machine. Depending on the OS you choose you might have to manually modify your /etc/hosts file to add the redirect.

Below you can see how I modified the hosts file. I ran this project on Debian 12. This might vary depending on the OS of your choice.

```c
127.0.0.1  localhost
127.0.1.1  user-VirtualBox
127.0.0.1  fsalazar.42.fr

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```


## Contributing

## License

[MIT](https://choosealicense.com/licenses/mit/)
