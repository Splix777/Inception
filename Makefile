DOCKER = sudo docker

COMPOSE = $(DOCKER)-compose -p inception -f srcs/docker-compose.yml

MARIADB_VOLUME = /home/splix/data/mariadb

WORDPRESS_VOLUME = /home/splix/data/wordpress

VOLUMES = $(MARIADB_VOLUME) $(WORDPRESS_VOLUME)

all: up

$(MARIADB_VOLUME):
	@echo "\033[1;33mCreating MariaDB volume\033[0m"
	@sudo mkdir -p $(MARIADB_VOLUME)

$(WORDPRESS_VOLUME):
	@echo "\033[1;33mCreating Wordpress volume\033[0m"
	@sudo mkdir -p $(WORDPRESS_VOLUME)

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

down:
	@echo "\033[1;33mDestroying containers\033[0m"
	@$(COMPOSE) down

clean:
	@echo "\033[1;33mDestroying containers, images and volumes\033[0m"
	@$(COMPOSE) down --rmi all --volumes

fclean: clean
	@echo "\033[1;33mFlushing Docker\033[0m"
	@$(DOCKER)-compose -f ./srcs/docker-compose.yml stop
	@$(DOCKER)-compose -f ./srcs/docker-compose.yml down -v
	@$(DOCKER) system prune --all --force
	@$(DOCKER) volume prune --force
	@$(DOCKER) network prune --force
	@$(DOCKER) image prune --force
	@if [ -d "/home/splix/data" ]; then sudo $(RM) -rf /home/splix/data; fi

re: fclean all

status:
	@echo "\n\033[1;33mContainers\033[0m"
	@$(DOCKER) ps -a
	@echo "\n\033[1;33mImages\033[0m"
	@$(DOCKER) images
	@echo "\n\033[1;33mVolumes\033[0m"
	@$(DOCKER) volume ls
	@echo "\n\033[1;33mNetworks\033[0m"
	@$(DOCKER) network ls

.PHONY: all ps images volumes networks start stop restart up down clean fclean re status
