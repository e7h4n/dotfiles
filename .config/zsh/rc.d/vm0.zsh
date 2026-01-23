# vm0 reset
alias vr='(git cm && git prune-all); (cd turbo && pnpm install && pnpm -F web db:migrate && pnpm test) && ccc'
