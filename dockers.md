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



### exec

```bash
# create a container for the image samtools in background (-d => `detached`). 
# This returns the long container ID
docker run -it -d samtools:latest

# see the container. Get the container id
docker container ls

# if no container appears, check the logs
docker logs <long_container_id>

# TEST: Execute a command from the container
docker exec -it <container_id_or_name> echo "Hello from container!"

# remove a container
docker container rm <container_id>
```



### Run docker non-root user
```bash
sudo groupadd docker
sudo usermod -aG docker $USER
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

