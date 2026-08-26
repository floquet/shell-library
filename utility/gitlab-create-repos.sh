#!/usr/bin/env bash
printf "%s\n" "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

counter=0
subcounter=0
start_time=${SECONDS}

function new_step() {
    export counter=$((counter + 1))
    export subcounter=0
    echo ""
    echo "Step ${counter}: ${1}"
}

function sub_step() {
    export subcounter=$((subcounter + 1))
    echo ""
    echo "  Substep ${counter}.${subcounter}: ${1}"
}

function display_total_elapsed_time() {
    local total_elapsed_time=$((SECONDS - start_time))
    local total_minutes=$((total_elapsed_time / 60))
    local total_seconds=$((total_elapsed_time % 60))
    echo ""
    printf "Total elapsed time: %02d:%02d (MM:SS)\n" \
        "$total_minutes" "$total_seconds"
}

root="$HOME/repos-$HOSTNAME/gitlab"
new_step "Set GitLab repository root to ${root}"

new_step "Build repository list"
    repos=(
        animations
        books-ams
        books-cup
        books-other
        icons
        mac-configurations
        mhd
        oeuvre
        placemat
        presentations
        simulation
        strange
        zazzle
    )

new_step "Verify GitLab authentication: glab auth status"
  glab auth status


new_step "Loop over repositories"
    for repo in "${repos[@]}"; do
        sub_step "Process ${repo}: cd into subdirectory"
            cd "${root}/${repo}" || continue

        if [[ ! -d .git ]]; then
            sub_step "Initialize ${repo} as a Git repository: git init"
                git init -b main

            sub_step "Add files for ${repo}: git add ."
                git add .

            sub_step "Create initial commit for ${repo}: git commit -m \"Initial import\""
                git commit -m "Initial import"
        else
            sub_step "${repo} already has local Git metadata: git status --short"
                git status --short
        fi

        if git remote get-url origin >/dev/null 2>&1; then
            sub_step "${repo} already has an origin remote: git remote -v"
                git remote -v
        else
            sub_step "Create private GitLab project ${repo}: gitlab repo create ${repo} --private --defaultBranch main"
                glab repo create "${repo}" --private --defaultBranch main --skipGitInit

            sub_step "Add GitLab SSH origin for ${repo}"
	            git remote add origin "git@gitlab.com:dantopa/${repo}.git"
        fi
        sub_step "Display remote for ${repo}: git remote -v"
            git remote -v

        sub_step "Push ${repo} to GitLab: git push -u origin main"
            git push -u origin main

    done

new_step "Return to GitLab repository root"
    sub_step "Change directory to ${root}"
        cd "${root}"

display_total_elapsed_time

