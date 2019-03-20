# Dockers

### list
```
# list images
docker images (or docker image ls)

# list containers 
docker ps (or docker container ls)
```



### pull / push
```
docker pull IMAGE
docker push IMAGE
```



### build
```
docker build -t samtools -f Dockerfile .
```

### remove
```
docker rmi <IMAGE>

docker stop <CONTAINER_ID>
docker rm <CONTAINER_ID>
```


### docker run and docker exec (only executes)
docker run runs a command in a new container that does not currently exist.
docker exec runs a command in an existing container.

```bash
# create a container for a docker image:tag in background (-d => `detached`). 
# This returns the long container ID
docker run -it -d <image>:<tag>

# get container-id by docker image name (e.g. intrepid_pasteur. a=all, q=quiet, f=filter)
CONTAINER_ID=$(docker ps -aqf name=pasteur)

# copy a file to a container
docker cp <my_file> $CONTAINER_ID:<file_path>

# access the container via bash
docker exec -it $CONTAINER_ID /bin/bash

# TEST: Execute a command from the container
docker exec -it $CONTAINER_ID echo "Hello from container!"

# if no container appears, check the logs
docker logs $CONTAINER_ID

# remove a container
docker container rm $CONTAINER_ID
```



### Run docker non-root user
```bash
sudo groupadd docker
sudo usermod -aG docker $USER
```


### Maintenance
```bash
# Remove unused dangling images
docker image prune
# Cleanup the system (unused containers, dangling images, ...)
docker system prune
```



### AWS

##### LOOK UP FOR RECENT DOCKER IMAGES
These images are generated from Circle-CI.

```bash
# check the available local images
docker image ls

# login to aws ecr
$(aws ecr get-login --no-include-email --region=eu-west-1)

# check the available tags on aws ecr
aws ecr describe-images --registry-id REGISTRY --repository-name REPOSITORY \
--region eu-west-1 --query 'sort_by(imageDetails,& imagePushedAt)[*]'
# less accurate
aws ecr list-images --registry-id REGISTRY --repository-name REPOSITORY \
--region eu-west-1
```

##### Getting AWS Credentials into a Docker Container without Hardcoding It
AWS credentials are in ~/.aws/credentials
```
AWS_ACCESS_KEY_ID=$(aws --profile PROFILE_NAME configure get aws_access_key_id)
AWS_SECRET_ACCESS_KEY=$(aws --profile PROFILE_NAME configure get aws_secret_access_key)

# -e ENV_VAR -v VOLUME --entrypoint
docker run -it --rm \
   -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
   -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
   samtools:latest
```

Now within the docker run: 
```
aws s3 ls s3://BUCKET_NAME/FILE_NAME
samtools view -H s3://BUCKET_NAME/FILE_NAME
```

