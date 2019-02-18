# AWS

### LOOK UP FOR RECENT DOCKER IMAGES
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
