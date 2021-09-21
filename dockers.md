# Dockers

### list
```
# list images
docker images (or docker image ls)

# list containers
docker ps (or docker container ls)
```


### LOOK UP FOR RECENT DOCKER IMAGES from AWS
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

### pull / push
```
docker pull IMAGE
docker push IMAGE
```


### build
##### simple
```
docker build -t samtools -f Dockerfile .
```
##### Using docker-compose
```
##################################################
# NOTE: if this does not work, check python-docker.
# curl -L https://github.com/docker/compose/releases/download/1.9.0/docker-compose-`uname -s`-`uname -m` --output docker-compose-download
# sudo mv docker-compose-download /usr/bin/docker-compose
# sudo chmod +x /usr/bin/docker-compose
##################################################
docker-compose up -d
```


### docker run and docker exec (only executes)

- `docker run`: Use this to run a command in a new container. It suits the situation where you do not have a container running, and you want to create one, start it and then run a process on it.
- `docker exec`: This is for when you want to run a command in an existing container. This is better if you already have a container running and want to change it or obtain something from it. For example, if you are using docker-compose you will probably spin-up multiple containers and you may want to access one or more of them once they are created.

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
```


### remove
```
docker rmi <IMAGE>

docker stop <CONTAINER_ID>
docker rm <CONTAINER_ID>
```

###### Cleanup the system (unused containers, dangling images, ...)
```
docker system prune
```

###### Remove unused dangling images
```
docker image prune
```

###### These commands can be done for all containers:
```
# stop and remove all docker containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
```



### Run docker non-root user
```bash
sudo groupadd docker
sudo usermod -aG docker $USER
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

