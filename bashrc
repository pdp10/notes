# Useful functions to add to .bashrc

# more ls alias
alias lt='ls -larth'

alias python=python3.10

# set the default editor
export VISUAL=nvim
export EDITOR="$VISUAL"
alias vim="$VISUAL"
alias vi="$VISUAL"


export PATH="~/.local/bin:$PATH"

# Load pyenv automatically by appending
# the following to 
# ~/.bash_profile if it exists, otherwise ~/.profile (for login shells)
# and ~/.bashrc (for interactive shells) :
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
# Load pyenv-virtualenv automatically by adding
# the following to ~/.bashrc:
eval "$(pyenv virtualenv-init -)"



alias aws_sso_login_dev='aws sso login --profile dev-sso'

alias aws_ecr_login='/usr/local/bin/aws ecr get-login-password --region eu-west-1 | docker login --password-stdin --username AWS ID.dkr.ecr.eu-west-1.amazonaws.com'

export AWS_DEFAULT_PROFILE=dev-sso

# -A to copy your credentials over
alias scp='scp -F ~/.ssh/config'
alias ssh='ssh -A'

# kubernetes
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
alias kctx='k config get-contexts'
alias kns='k get namespaces'
alias kcm='k get configmaps'
alias kpods='k get pods'

kchns() {
    # kubernetes set default namespace for the current context
    k config set-context $(k config current-context) --namespace=$1
}

kchctx() {
    # kubernetes change context
    k config use-context $1
}

kexec() {
    # kubernetes exec pod
    k exec -it $1 -- bash
}

kjr() {
    local _container="job-runner"
    local _app="$( k get deployments ${_container} -ojson | jq '.metadata.labels.app' | tr -d '\"')"
    local _pod="$( k get pods -l app=${_app} --no-headers -o custom-columns=':metadata.name' )"
    k exec -it ${_pod} -c ${_container} -- bash
}

kdb() {
    local _container="sapweb"
    local _app="$( k get deployments ${_container} -ojson | jq '.metadata.labels.app' | tr -d '\"')"
    local _pod="$( k get pods -l app=${_app} --no-headers -o custom-columns=':metadata.name' )"

    local _pod_env="$( k exec -it ${_pod} -c ${_container} -- env)"
    local _db_host="$( echo "${_pod_env}" | grep DB_HOST | cut -d= -f2 | tr -d '\r')"
    local _db_port="$( echo "${_pod_env}" | grep DB_PORT | cut -d= -f2 | tr -d '\r')"
    local _db_name="$( echo "${_pod_env}" | grep DB_NAME | cut -d= -f2 | tr -d '\r')"
    local _db_user="$( echo "${_pod_env}" | grep DB_USER | cut -d= -f2 | tr -d '\r')"
    local _db_pwd="$( echo "${_pod_env}" | grep DB_PASSWORD | cut -d= -f2 | tr -d '\r')"
    #echo "PGPASSWORD=${_db_pwd} psql -U ${_db_user} -h ${_db_host} -d ${_db_name}" > /dev/stderr
    k exec -it ${_pod} -c ${_container} -- bash -c "PGPASSWORD=${_db_pwd} psql -U ${_db_user} -h ${_db_host} -d ${_db_name} -p ${_db_port}"
}

docker_tags() {
    # return the docker tags for a certain image (e.g. sapientia-web)
    /usr/local/bin/aws ecr describe-images --registry-id ID --repository-name REPO/dev/$1 --region REGION --query 'sort_by(imageDetails,& imagePushedAt)[]'
}

