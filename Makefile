DOCKER = sudo docker
COMPOSE = $(DOCKER)-compose -p inception -f srcs/docker-compose.yml
MARIADB_VOLUME = /home/splix/data/mariadb
WORDPRESS_VOLUME = /home/splix/data/wordpress
DEPENDENCIES = $(MARIADB_VOLUME) $(WORDPRESS_VOLUME)

all: up

$(MARIADB_VOLUME):
	sudo mkdir -p $(MARIADB_VOLUME)

$(WORDPRESS_VOLUME):
	sudo mkdir -p $(WORDPRESS_VOLUME)

ps:
	$(COMPOSE) ps

images:
	$(COMPOSE) images

volumes:
	$(DOCKER) volume ls

networks:
	$(DOCKER) network ls

start: $(DEPENDENCIES)
	$(COMPOSE) start

stop:
	$(COMPOSE) stop

restart: $(DEPENDENCIES)
	$(COMPOSE) restart

up: $(DEPENDENCIES)
	$(COMPOSE) up --detach --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down --rmi all --volumes

fclean: clean
	$(DOCKER)-compose -f ./srcs/docker-compose.yml stop
	$(DOCKER)-compose -f ./srcs/docker-compose.yml down -v
	$(DOCKER) system prune --all --force
	$(DOCKER) volume prune --force
	$(DOCKER) network prune --force
	$(DOCKER) image prune --force
	@if [ -d "/home/splix/data" ]; then sudo $(RM) -rf /home/splix/data; fi

prune: down fclean
	$(DOCKER) system prune -a -f

re: fclean all

status:
	@echo "\n\033[1;33mContainers\033[0m"
	$(DOCKER) ps -a
	@echo "\n\033[1;33mImages\033[0m"
	$(DOCKER) images
	@echo "\n\033[1;33mVolumes\033[0m"
	$(DOCKER) volume ls
	@echo "\n\033[1;33mNetworks\033[0m"
	$(DOCKER) network ls

.PHONY: all ps images volumes networks start stop restart up down clean fclean prune re status

