DOCKER = docker

COMPOSE = $(DOCKER)-compose -p inception -f srcs/docker-compose.yml

# -p inception: The -p or --project-name flag specifies the project name. In your command, you've set the project name to "inception." The project name is used to namespace containers, networks, and other resources created by Docker Compose. It helps in organizing and isolating resources for different projects. In this case, all resources created by this docker-compose command will be prefixed with "inception."
# -f srcs/docker-compose.yml: The -f or --file flag allows you to specify the location of the docker-compose.yml file that defines the configuration for your multi-container application. In your command, you've provided the path to the docker-compose.yml file as srcs/docker-compose.yml. This flag is used to select a specific docker-compose.yml file when you have multiple configuration files in your project directory.

MARIADB_VOLUME = /home/splix/data/mariadb

WORDPRESS_VOLUME = /home/splix/data/wordpress

VOLUMES = $(MARIADB_VOLUME) $(WORDPRESS_VOLUME)

all: up

$(MARIADB_VOLUME):
	@echo "\033[1;33mCreating MariaDB volume\033[0m"
	@mkdir -p $(MARIADB_VOLUME)
# The -p flag in the mkdir command stands for "parents" and is used to create a directory and any necessary parent directories (also known as parent directories or intermediate directories) in the specified path. If the parent directories don't exist, the -p flag ensures that they are created along with the target directory.

$(WORDPRESS_VOLUME):
	@echo "\033[1;33mCreating Wordpress volume\033[0m"
	@mkdir -p $(WORDPRESS_VOLUME)

start: $(VOLUMES)
	@echo "\033[1;33mStarting containers\033[0m"
	@$(COMPOSE) start

stop:
	@echo "\033[1;33mStopping containers\033[0m"
	@$(COMPOSE) stop

restart: $(VOLUMES)
	@echo "\033[1;33mRestarting containers\033[0m"
	@$(COMPOSE) restart

up: $(VOLUMES)
	@echo "\033[1;33mStarting containers\033[0m"
	@$(COMPOSE) up --detach --build
# --detach:
# 	The --detach (or -d) flag tells Docker Compose to run containers in the background as detached processes. When you use this flag, the terminal is not attached to the container's output, and you can continue using the terminal for other tasks.
#	This is useful when you want to start your services and keep them running in the background without tying up your terminal. You can later use docker-compose logs or other commands to inspect the container logs.
# --build:
#	The --build flag tells Docker Compose to rebuild the images for the services defined in the docker-compose.yml file before starting the containers. It's used when you want to ensure that the most up-to-date images are used, incorporating any changes you may have made to the application code or the Dockerfile.
down:
	@echo "\033[1;33mDestroying containers\033[0m"
	@$(COMPOSE) down

clean:
	@echo "\033[1;33mDestroying containers, images and volumes\033[0m"
	@$(COMPOSE) down --rmi all --volumes
# --rmi all:
#	The --rmi all flag instructs Docker Compose to remove all images used by the services defined in the docker-compose.yml file. This includes both images that were built for your services and images that were pulled from registries
# --volumes:
#	The --volumes flag is used in conjunction with docker-compose down to remove named volumes associated with your Docker Compose services.
fclean: clean
	@echo "\033[1;33mFlushing Docker\033[0m"
	@$(DOCKER)-compose -f ./srcs/docker-compose.yml stop
	@$(DOCKER)-compose -f ./srcs/docker-compose.yml down -v
# -v: Same as --volumes above. --volumes is the long version of -v, makes it easier to remember.
	@$(DOCKER) system prune --all --force
# --all: The --all flag tells Docker to remove all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes.
# --force: The --force flag tells Docker to skip the prompt that asks you to confirm that you want to remove the images.
	@$(DOCKER) volume prune --force
	@$(DOCKER) network prune --force
	@$(DOCKER) image prune --force
	@if [ -d "/home/splix/data" ]; then $(RM) -rf /home/splix/data; fi
# -d: -d checks for directory existence.

re: fclean all

status:
	@echo "\n\033[1;33mContainers\033[0m"
	@$(DOCKER) ps -a
# docker ps: This command, without any additional flags, lists only the currently running containers.
# docker ps -a: The -a flag tells Docker to list all containers, including those that are stopped.
	@echo "\n\033[1;33mImages\033[0m"
	@$(DOCKER) images
	@echo "\n\033[1;33mVolumes\033[0m"
	@$(DOCKER) volume ls
	@echo "\n\033[1;33mNetworks\033[0m"
	@$(DOCKER) network ls

.PHONY: all ps images volumes networks start stop restart up down clean fclean re status
