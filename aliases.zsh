# ===================
# Aliases
# ===================

# Xcode
alias xcodeclean="rm -rf ~/Library/Developer/Xcode/DerivedData"

# Git
alias nevermind="git reset --hard HEAD"
alias gw="git worktree"

# ===================
# Git Worktree Functions
# ===================

# git worktree add
gwa() {
    if [ -z "$1" ]; then
        echo "Usage: gwa <branch-name> [base-branch]"
        echo "Examples:"
        echo "  gwa fc/feature1           # 현재 커밋 기반"
        echo "  gwa fc/feature2 develop   # develop 기반"
        echo "  gwa fc/feature3 main      # main 기반"
        return 1
    fi

    local branch_name="$1"
    local base_branch="$2"
    local folder_name="${branch_name//\//-}"

    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        git worktree add "../$folder_name" "$branch_name"
    else
        if [ -n "$base_branch" ]; then
            git worktree add "../$folder_name" -b "$branch_name" "$base_branch"
        else
            git worktree add "../$folder_name" -b "$branch_name"
        fi
    fi
}

# git worktree change (fzf)
gwc() {
    local query="$1"
    local selected=$(git worktree list --porcelain | awk '
        /^worktree/ { path = $2 }
        /^branch/ {
            gsub(/^refs\/heads\//, "", $2)
            print $2 "\t" path
        }
    ' | fzf --height=40% --reverse --prompt="Select branch: " --query="$query" --with-nth=1 | cut -f2)

    if [ -n "$selected" ]; then
        cd "$selected"
    fi
}

# git worktree remove (fzf)
gwr() {
    local query="$1"

    local selected=$(git worktree list --porcelain | awk '
        /^worktree/ { path = $2 }
        /^branch/ {
            gsub(/^refs\/heads\//, "", $2)
            print $2 "\t" path
        }
    ' | fzf --height=40% --reverse --prompt="Select worktree to remove: " --query="$query" --with-nth=1)

    if [ -n "$selected" ]; then
        local branch=$(echo "$selected" | cut -f1)
        local path=$(echo "$selected" | cut -f2)

        echo "Remove worktree?"
        echo "  Branch: $branch"
        echo "  Path: $path"
        read -q "REPLY?Continue? (y/n) "
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Removing folder..."
            /bin/rm -rf "$path"

            echo "Pruning worktree list..."
            git worktree prune

            echo "✓ Removed"
        else
            echo "Cancelled"
        fi
    fi
}
