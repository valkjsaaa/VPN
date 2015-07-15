# Build a container via the command "make build"
# By Jason Gegere <jason@htmlgraphic.com>

VERSION 			= 0.3.1
NAME 				= vpn
IMAGE_REPO 	= htmlgraphic
IMAGE_NAME 	= $(IMAGE_REPO)/$(NAME)

all:: help


help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "     make build		- Build image $(IMAGE_NAME):$(VERSION)"
	@echo "     make push		- Push $(IMAGE_NAME):$(VERSION) to public docker repo"
	@echo "     make run		- Create a container for $(NAME)"
	@echo "     make start		- Start the EXISTING $(NAME) container"
	@echo "     make stop		- Stop $(NAME) container"
	@echo "     make restart	- Stop and start $(NAME) container"
	@echo "     make rm		- Stop and remove $(NAME) container"
	@echo "     make state		- View state $(NAME) container"
	@echo "     make logs		- View logs in real time"

build:
	docker build --rm --no-cache -t $(IMAGE_NAME):$(VERSION) .

push:
	@echo "note: If the repository is set as an automated build you will NOT be able to push"
	docker push $(IMAGE_NAME):$(VERSION)

run:
	docker run -d -p 1723:1723 --privileged --name $(NAME) $(IMAGE_NAME):$(VERSION)

start:
	@echo "Starting $(NAME)..."
	docker start $(NAME) > /dev/null

stop:
	@echo "Stopping $(NAME)..."
	docker stop $(NAME) > /dev/null

restart: stop start

rm: stop
	@echo "Removing $(NAME)..."
	docker rm $(NAME) > /dev/null

state:
	docker ps -a | grep $(NAME)

logs:
	@echo "Build $(NAME)..."
	docker logs -f $(NAME)
