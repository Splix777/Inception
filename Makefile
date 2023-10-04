all : up

up : 
	@sudo mkdir -p /home/${USER}/data/mariadb
	@sudo mkdir -p /home/${USER}/data/wordpress
	@sudo docker-compose -f ./srcs/docker-compose.yml up -d

down : 
	@sudo docker-compose -f ./srcs/docker-compose.yml down

stop : 
	@sudo docker-compose -f ./srcs/docker-compose.yml stop

start : 
	@sudo docker-compose -f ./srcs/docker-compose.yml start

fclean :
	@sudo docker-compose -f ./srcs/docker-compose.yml stop
	@sudo docker-compose -f ./srcs/docker-compose.yml down -v
	@sudo docker system prune --all --force
	@sudo docker volume prune --force
	@sudo docker network prune --force
	@sudo docker image prune --force
	@if [ -d "/home/${USER}/data" ]; then sudo rm -r /home/${USER}/data; fi
	

status : 
	@echo "\n\033[1;33mContainers\033[0m"
	@sudo docker ps
	@echo "\n\033[1;33mVolumes\033[0m"
	@sudo docker volume ls
	@echo "\n\033[1;33mImages\033[0m"
	@sudo docker images
	@echo "\n\033[1;33mNetworks\033[0m"
	@sudo docker network ls

.PHONY: all up down stop start fclean status