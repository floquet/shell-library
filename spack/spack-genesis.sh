#!/usr/bin/env bash
printf "%s\n" "$(tput bold)$(date) ${BASH_SOURCE[0]}$(tput sgr0)"

# invocation (creates subdirectory kaeden-spack)
# ./spack-genesis.sh
# source spack-genesis

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

new_step 'clone spack into the subdirectory kaeden-spack'
    git clone --depth 1 https://github.com/spack/spack.git kaeden-spack

new_step 'initialize spack'
    sub_step 'cd kaeden-spack'
              cd spack
    sub_step '../share/spack/setup-env.sh'

new_step 'first use only: have spack interrogate for compilers with "spack compiler find"'
    spack compiler find

new_step 'install a small package, here zlib and interrogate'
    sub_step 'spack install zlib'
              spack install zlib
    sub_step 'list packages built by spack using "spack find"'
              spack find
    sub_step 'spack detail zlib'
              spack detail zlib
    sub_step 'spack graph zlib'
              spack graph zlib
    sub_step 'spack spec zlib'
              spack spec zlib
    sub_step 'spack info zlib'
              spack info zlib

new_step 'For a sense of accomplishment, try "spack install llvm" or "spack install gcc"

display_total_elapsed_time 


