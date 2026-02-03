#!/usr/bin/env bash

set -eu

# 默认值
GIT_USER_NAME="${GIT_USER_NAME:-Ethan Zhang}"
GIT_USER_EMAIL="${GIT_USER_EMAIL:-ethan@vm0.ai}"

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --name)
            GIT_USER_NAME="$2"
            shift 2
            ;;
        --email)
            GIT_USER_EMAIL="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [--name <name>] [--email <email>]"
            echo "  --name   Git user name (default: Ethan Zhang)"
            echo "  --email  Git user email (default: ethan@vm0.ai)"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

cat > $HOME/.gitignore.global << EOF
.DS_Store
EOF

cat > $HOME/.gitconfig << EOF
[color]
    ui = true
    diff = true
    status = true
    branch = true
    interactive = true
[core]
    excludesfile = ~/.gitignore.global
[alias]
    l = log --decorate --graph
    la = log --decorate --graph --all
    ba = branch -a
    ci = commit
    dc = diff --cached
    ca = commit --amend
    rc = rebase --continue
    ri = !git fetch && git rebase -i origin/main
    mb = !git fetch && git merge origin/main
    aa = add --all
    cb = !git checkout -b branch-\$(head -c 4 /dev/urandom | xxd -p)
    cm = !git checkout main && git pull
    pr = !git push -u origin \$(git branch --show-current)
    prune-all = !git remote | xargs -n1 git remote prune && git branch | grep -v main | xargs git branch -D
[branch]
    autosetuprebase = always
[push]
    default = simple
[delta]
    side-by-side = true
[pull]
    rebase = true
[init]
    defaultBranch = main
[user]
    name = $GIT_USER_NAME
    email = $GIT_USER_EMAIL
EOF

cat > $HOME/.gitattributes << EOF
# Auto detect text files and perform LF normalization
* text=auto
EOF
