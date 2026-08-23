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

new_step "Create stub name"
  stub="git clone git@bitbucket.org:dantopa/"

new_step "Build repo list"
  repos="books-cup,"
new_step "Loop over repos"

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

for repo in "${repos[@]}"; do
    sub_step "git clone --depth 1  git@bitbucket.org:dantopa/${repo}.git"
              git clone --depth 1 "git@bitbucket.org:dantopa/${repo}.git" &
done

new_step "Wait and keep the shell script alive until all clones finish"
  wait


display_total_elapsed_time 


