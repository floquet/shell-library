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
new_step "Create spack-jupyter directory inside ~/spacktivity"
mkdir -p "$HOME/spacktivity"
cd "$HOME/spacktivity" || exit 1

sub_step "Clone Spack into spack-jupyter"
git clone https://github.com/spack/spack.git spack-jupyter

new_step "Create user setup directory inside SPACK_ROOT"
cd "$HOME/spacktivity/spack-jupyter" || exit 1
mkdir -p "$(whoami)/setup/scripts"

sub_step "Drop marker file"
touch "$(whoami)/setup/.initialized"

sub_step "Copy this setup script into scripts/"
cp "$0" "$(whoami)/setup/scripts/$(basename "$0")"

display_total_elapsed_time

