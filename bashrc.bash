# CUSTOM BASHRC STUFF

rga-fzf() {
    RG_PREFIX="rga --files-with-matches"
    local file
    file="$(
        FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
            fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
            --phony -q "$1" \
            --bind "change:reload:$RG_PREFIX {q}" \
            --preview-window="70%:wrap"
    )" &&
        echo "opening $file" &&
        xdg-open "$file"
}

ct-create-timestamp-dir() {
    name="$(date --iso-8601)-$@"
    mkdir "$name"
    cd "$name"
}

ct-create-timestamp-file() {
    name="$(date --iso-8601)-$@"
    touch "$name"
    xdg-open "$name"
}

ct-git-sync() {
    git add -A
    commit_msg="$(date --iso-8601=seconds) -- $(hostname)"
    git commit -m "$commit_msg"
    git push
}

ct-git-set-local() {
    read -p "Enter local email for git: " GIT_MAIL && git config user.email "${GIT_MAIL}"
    read -p "Enter local name for git: " GIT_NAME && git config user.name "${GIT_NAME}"
    git config user.email
    git config user.name
}

alias isodate='date --iso-8601'

# FZF commands - source https://github.com/junegunn/fzf/wiki/examples#processes

