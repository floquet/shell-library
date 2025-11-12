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
    printf "Total elapsed time: %02d:%02d (MM:SS)\n" "$total_minutes" "$total_seconds"
}

# Begin steps
for dir in */; do
    if [ -d "$dir/.git" ]; then
        #echo "================================"
        #echo "Repository: $dir"
        #echo "================================"
        new_step "cd $dir"
                  cd "$dir"
        sub_step "git pull"
                  git pull
        sub_step "git status"
                  git status
        sub_step "cd .."
                  cd ..
    fi
done

display_total_elapsed_time

