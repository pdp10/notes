# Useful functions to add to .bashrc

# more ls alias
alias lt='ls -larth'

alias python3=python3.6

# set the default editor
export VISUAL=nvim
export EDITOR="$VISUAL"
alias vim="$VISUAL"
alias vi="$VISUAL"

alias aws_connect='/usr/local/bin/aws ecr get-login-password --region eu-west-1 | docker login --password-stdin --username AWS 144563655722.dkr.ecr.eu-west-1.amazonaws.com'

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

ksw() {
    local _container="sapientia-web"
    local _app="$( k get deployments ${_container} -ojson | jq '.metadata.labels.app' | tr -d '\"')"
    local _pod="$( k get pods -l app=${_app} --no-headers -o custom-columns=':metadata.name' )"
    k exec -it ${_pod} -c ${_container} -- bash
}

ksc() {
    local _container="sapctl"
    local _app="$( k get deployments ${_container}-deployment -ojson | jq '.metadata.labels.app' | tr -d '\"')"
    local _pod="$( k get pods -l app=${_app} --no-headers -o custom-columns=':metadata.name' )"
    k exec -it ${_pod} -c ${_container} -- bash
}

kdb() {
    local _container="sapientia-web"
    local _app="$( k get deployments ${_container} -ojson | jq '.metadata.labels.app' | tr -d '\"')"
    local _pod="$( k get pods -l app=${_app} --no-headers -o custom-columns=':metadata.name' )"
    local _db_host="$( k exec -it ${_pod} -c ${_container} -- env | grep SAPIENTIA_DB_HOST | cut -d= -f2 | tr -d '\r')"
    local _db_port="$( k exec -it ${_pod} -c ${_container} -- env | grep SAPIENTIA_DB_PORT | cut -d= -f2 | tr -d '\r')"
    local _db_name="$( k exec -it ${_pod} -c ${_container} -- env | grep SAPIENTIA_DB_NAME | cut -d= -f2 | tr -d '\r')"
    local _db_user="$( k exec -it ${_pod} -c ${_container} -- env | grep SAPIENTIA_DB_USER | cut -d= -f2 | tr -d '\r')"
    local _db_pwd="$( k exec -it ${_pod} -c ${_container} -- env | grep SAPIENTIA_DB_PASSWORD | cut -d= -f2 | tr -d '\r')"
    #echo "PGPASSWORD=${_db_pwd} psql -U ${_db_user} -h ${_db_host} -d ${_db_name}" > /dev/stderr
    k exec -it ${_pod} -c ${_container} -- bash -c "PGPASSWORD=${_db_pwd} psql -U ${_db_user} -h ${_db_host} -d ${_db_name} -p ${_db_port}"
}

docker_tags() {
    # return the docker tags for a certain image (e.g. sapientia-web)
    /usr/local/bin/aws ecr describe-images --registry-id 144563655722 --repository-name congenica/dev/$1 --region eu-west-1 --query 'sort_by(imageDetails,& imagePushedAt)[]'
}

