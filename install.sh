#!/usr/bin/env bash

set -e

dotfiles_dir="$HOME"/dotfiles
cache_dir="$HOME/.cache/dotfiles"

clone_or_pull() {
    local repo_url="$1"
    local cache_path="$2"
    local dest_path="$3"

    if [ -d "$cache_path" ]; then
        git -C "$cache_path" pull
    else
        git clone --depth 1 "$repo_url" "$cache_path"
    fi
    rm -rf "$dest_path"
    cp -r "$cache_path" "$dest_path"
}

mkdir -p "$cache_dir"
mkdir -p "$HOME/.zsh"

clone_or_pull "https://github.com/sindresorhus/pure.git" "$cache_dir/pure" "$HOME/.zsh/pure"
clone_or_pull "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$cache_dir/zsh-syntax-highlighting" "$HOME/.zsh/zsh-syntax-highlighting"

cat > $HOME/.zshrc << EOF
fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="\$HOME/.local/bin:\$PATH"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export CLAUDE_CODE_DISABLE_TERMINAL_TITLE=1

alias ..='cd ..'
alias ccc='claude --dangerously-skip-permissions'
alias cccc='ccc --continue'
alias gws='git status'
alias glgga='git log --all --decorate --graph'
alias vr='(git cm && git prune-all); (cd turbo && pnpm install && pnpm -F web db:migrate && pnpm test) && ccc'
EOF

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
    fu = submodule foreach 'git checkout master && git pull'
    rc = rebase --continue
    ri = !git fetch && git rebase -i origin/main
    mb = !git fetch && git merge origin/main
    aa = add --all
    cb = !git checkout -b feat-\$(uuidgen | tr -d - | head -c8)
    cm = !git checkout main && git pull
    ghs = !git fetch && git push github origin/main:main
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
    name = Ethan Zhang
    email = ethan@vm0.ai
EOF

cat > $HOME/.gitattributes << EOF
# Auto detect text files and perform LF normalization
* text=auto
EOF

cat > $HOME/.agignore << EOF
target
node_modules
vendor
logs
EOF


curl -fsSL https://claude.ai/install.sh | \
  sed -e 's|DOWNLOAD_DIR="\$HOME/.claude/downloads"|DOWNLOAD_DIR="$HOME/.cache/claude"|' \
      -e 's|"\$binary_path" install.*|"\$binary_path" install \$version|' \
      -e '/rm -f "\$binary_path"/d' \
      -e '/version=\$(download_file.*latest")/a echo claude code version: $version' \
      -e 's|if ! download_file|if [ -f "\$binary_path" ]; then echo "Using cached binary"; elif ! download_file|' | \
  bash
