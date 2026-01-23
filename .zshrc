export PATH="$HOME/.local/bin:$PATH"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
alias ccc='~/.local/bin/claude --dangerously-skip-permissions'
alias cccc='ccc --continue'
alias gws='git status'
alias glgga='git log --all --decorate --graph'
alias vr='(git cm && git prune-all); (cd turbo && pnpm install && pnpm -F web db:migrate && pnpm test) && ccc'
