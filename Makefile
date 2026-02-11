.PHONY: all up down clean fclean re

all: up

up:
	@mkdir -p /home/enzuguem/data/wordpress
	@mkdir -p /home/enzuguem/data/mariadb
	@cd srcs && docker compose up -d --build

down:
	@cd srcs && docker compose down

clean:
	@cd srcs && docker compose down -v

fclean: clean
	@docker system prune -af --volumes

re: fclean all
