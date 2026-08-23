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

new_step "Create key name: id_${HOSTNAME}_gitlab_ed25519"
  key_name="id_${HOSTNAME}_gitlab_ed25519"

new_step "Generate ssh-skey: ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_${HOSTNAME}_gitlab -C '{$HOSTNAME}-gitlab'"
  ssh-keygen -t ed25519 \
    -f ~/.ssh/${key_name} \
    -C "${HOSTNAME}-gitlab"

new_step "Show public key to copy into buffer: "  
   cat ~/.ssh/${key_name}.pub

display_total_elapsed_time 


