include ../../../make.inc

# Cargar variables .env
include .env
export $(shell sed 's/=.*//' .env)

# Build the Docker image
build_docker_image:
	docker build -t $(DOCKER_IMAGE_NAME) .

# Run the image locally
run_docker_image:
	docker run --rm -it -p $(PORT):$(PORT) -e PORT=$(PORT) $(DOCKER_IMAGE_NAME)

# Push the image to Artifact Registry
push_docker_image:
	docker push $(DOCKER_IMAGE_NAME)

# Deploy to Cloud Run
deploy_docker_image:
	gcloud run deploy fastapi-deployment \
		--image=$(DOCKER_IMAGE_NAME) \
		--platform=managed \
		--region=$(LOCATION) \
		--allow-unauthenticated \
		--port=$(PORT)
