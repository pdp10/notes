# Notes about circleci (local execution)

sudo snap install docker circleci
sudo snap connect circleci:docker docker
circleci setup
circleci config validate
circleci config validate .circleci/config.yml



circleci config process .circleci/config.yml > process.yml && circleci local execute -c process.yml --job build_docker_image
