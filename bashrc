# Useful functions to add to .bashrc


# git (e.g. git co -> git checkout)
git config --global alias.co checkout
git config --global alias.nb 'checkout -b'
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
# add git branch to shell
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
# colours: https://misc.flogisoft.com/bash/tip_colors_and_formatting
export PS1="\[\e[92m\]\u@\h:\[\e[96m\]\w\[\e[93m\]\$(parse_git_branch)\[\e[37m\]\$ "

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# main aliases and colors
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias la='ls -A'
alias lt='ls -larth'
alias ls='ls --color=auto'

# python
#alias python=python3.12

# set the default editor
export VISUAL=nvim
export EDITOR="$VISUAL"
alias vim="$VISUAL"
alias vi="$VISUAL"


export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

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


# aws sso logins
alias aws_sso_login_core_internal_genome_data_prod_ro='aws sso login --profile core_internal_genome_data_prod_ro'
alias aws_sso_login_core_shared='aws sso login --profile core_shared'
alias aws_sso_login_genie_uat_admin='aws sso login --profile genie_uat_admin'
alias aws_sso_login_rdp_dev_admin='aws sso login --profile research_data_products_dev_admin'
alias aws_sso_login_rdp_dev_ro='aws sso login --profile research_data_products_dev_ro'
alias aws_sso_login_rdp_preprod_admin='aws sso login --profile research_data_products_preprod_admin'
alias aws_sso_login_rdp_preprod_ro='aws sso login --profile research_data_products_preprod_ro'
alias aws_sso_login_rdp_prod_admin='aws sso login --profile research_data_products_prod_admin'
alias aws_sso_login_rdp_prod_ro='aws sso login --profile research_data_products_prod_ro'
alias aws_sso_login_rdp_test_admin='aws sso login --profile research_data_products_test_admin'
alias aws_sso_login_rdp_test_ro='aws sso login --profile research_data_products_test_ro'

# alias aws_ecr_login='/usr/local/bin/aws ecr get-login-password --region eu-west-1 | docker login --password-stdin --username AWS ID.dkr.ecr.eu-west-1.amazonaws.com'

# export AWS_DEFAULT_PROFILE=dev-sso

# -A to copy your credentials over
alias scp='scp -F ~/.ssh/config'
alias ssh='ssh -A'

# kubernetes
#source <(kubectl completion bash)
alias k=kubectl
#complete -F __start_kubectl k   # not available on mac os x
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


