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
alias scp='scp -F -A ~/.ssh/config'

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

docker_tags() {
    # return the docker tags for a certain image (e.g. sapientia-web)
    /usr/local/bin/aws ecr describe-images --registry-id 144563655722 --repository-name congenica/dev/$1 --region eu-west-1 --query 'sort_by(imageDetails,& imagePushedAt)[]'
}


# add DB access so that you don't need to get the env vars every time
