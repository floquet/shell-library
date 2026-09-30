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
              cd kaeden-spack
    sub_step 'source share/spack/setup-env.sh'
              source share/spack/setup-env.sh

new_step 'first use only: have spack interrogate for compilers with "spack compiler find"'
    spack compiler find

new_step 'install a small package (here zlib) and run queries'
    sub_step 'spack install zlib'
              spack install zlib
    sub_step 'list packages built by spack using "spack find"'
              spack find
    sub_step 'spack graph zlib'
              spack graph zlib
    sub_step 'spack spec zlib'
              spack spec zlib
    sub_step 'spack info zlib'
              spack info zlib

new_step 'For a sense of accomplishment, try "spack install llvm" or "spack install gcc"'

display_total_elapsed_time 

# dantopa@isomer:~/spacktivity$ /home/dantopa/repos-isomer/github/shell-library/spack/spack-genesis.sh
# Tue Sep 29 09:41:58 PM MDT 2026 /home/dantopa/repos-isomer/github/shell-library/spack/spack-genesis.sh
 
# Step 1: clone spack into the subdirectory kaeden-spack
# Cloning into 'kaeden-spack'...
# remote: Enumerating objects: 2466, done.
# remote: Counting objects: 100% (2466/2466), done.
# remote: Compressing objects: 100% (1651/1651), done.
# remote: Total 2466 (delta 330), reused 1375 (delta 249), pack-reused 0 (from 0)
# Receiving objects: 100% (2466/2466), 5.67 MiB | 13.16 MiB/s, done.
# Resolving deltas: 100% (330/330), done.
 
# Step 2: initialize spack
 
#   Substep 2.1: cd kaeden-spack
 
#   Substep 2.2: source share/spack/setup-env.sh
 
# Step 3: first use only: have spack interrogate for compilers with "spack compiler find"
# remote: Enumerating objects: 20807, done.
# remote: Counting objects: 100% (20807/20807), done.
# remote: Compressing objects: 100% (11282/11282), done.
# remote: Total 20807 (delta 1347), reused 14454 (delta 1160), pack-reused 0 (from 0)
# ==> Added 4 new compilers to /home/dantopa/.spack/packages.yaml
#     llvm@21.1.8  gcc@16.0.1  gcc@15.2.0  gcc@14.3.0
# ==> Compilers are defined in the following files:
#     /home/dantopa/.spack/packages.yaml
 
# Step 4: install a small package (here zlib) and run queries
 
#   Substep 4.1: spack install zlib
# ==> Installing "clingo-bootstrap@=spack~apps~docs+ipo+optimized+python+static_libstdcpp build_system=cmake build_type=Release commit=2a025667090d71b2c9dce60fe924feb6bde8f667 generator=make patches=bebb819,ec99431 platform=linux os=centos7 target=x86_64" from a buildcache
# [e] jhfwru7 glibc@2.43 /usr (0s)
# [e] ig45adz gcc@16.0.1 /usr (0s)
# [+] dm35jne compiler-wrapper@1.1.0 /home/dantopa/spacktivity/kaeden-spack/opt/spack/linux-alderlake/compiler-wrapper-1.1.0-dm35jneu35elhjj5wdzt6uzpox72jlbo (0s)
# [+] nljrt3u gcc-runtime@16.0.1 /home/dantopa/spacktivity/kaeden-spack/opt/spack/linux-alderlake/gcc-runtime-16.0.1-nljrt3udhhgjb2ulw26qxsbqmowa2gsa (0s)
# [+] lwuzmij gmake@4.4.1 /home/dantopa/spacktivity/kaeden-spack/opt/spack/linux-alderlake/gmake-4.4.1-lwuzmijnf7zzlfxftltabj265pjnge72 (11s)
# [+] 3j7e2qy zlib@1.3.2 /home/dantopa/spacktivity/kaeden-spack/opt/spack/linux-alderlake/zlib-1.3.2-3j7e2qyfnftfu66t5autnkzutr3kio7z (1s)
 
#   Substep 4.2: list packages built by spack using "spack find"
# -- linux-ubuntu26.04-alderlake / %c,cxx=gcc@16.0.1 --------------
# zlib@1.3.2
 
# -- linux-ubuntu26.04-alderlake / %c=gcc@16.0.1 ------------------
# gmake@4.4.1
 
# -- linux-ubuntu26.04-alderlake / no compilers -------------------
# compiler-wrapper@1.1.0  gcc-runtime@16.0.1
 
# -- linux-ubuntu26.04-x86_64 / no compilers ----------------------
# gcc@16.0.1  glibc@2.43
# ==> 6 installed packages
 
#   Substep 4.3: spack graph zlib
# o zlib@1.3.2/3j7e2qy
# |\
# | |\
# | | |\
# | | | |\
# o | | | | gmake@4.4.1/lwuzmij
# |\| | | | 
# |\ \ \ \ \
# | |_|/ / /
# |/| | | | 
# | |\ \ \ \
# | | |_|/ /
# | |/| | | 
# | | |/ /
# | | o | compiler-wrapper@1.1.0/dm35jne
# | |  /
# o | | gcc-runtime@16.0.1/nljrt3u
# |\| | 
# | |/
# |/| 
# | o gcc@16.0.1/ig45adz
# | 
# o glibc@2.43/jhfwru7
 
#   Substep 4.4: spack spec zlib
# [+]  zlib@1.3.2+optimize+pic+shared build_system=makefile platform=linux os=ubuntu26.04 target=alderlake %c,cxx=gcc@16.0.1
# [+]      ^compiler-wrapper@1.1.0 build_system=generic platform=linux os=ubuntu26.04 target=alderlake 
# [e]      ^gcc@16.0.1+binutils+bootstrap+futex~graphite+libsanitizer~mold~nvptx~piclibs~profiled~strip build_system=autotools build_type=Release languages:='c,c++,fortran' platform=linux os=ubuntu26.04 target=x86_64 
# [+]      ^gcc-runtime@16.0.1 build_system=generic platform=linux os=ubuntu26.04 target=alderlake 
# [e]      ^glibc@2.43 build_system=autotools platform=linux os=ubuntu26.04 target=x86_64 
# [+]      ^gmake@4.4.1~guile build_system=generic platform=linux os=ubuntu26.04 target=alderlake %c=gcc@16.0.1
 
#   Substep 4.5: spack info zlib
# MakefilePackage:   zlib
 
# Description:
#     A free, general-purpose, legally unencumbered lossless data-compression
#     library.
 
# Homepage: https://zlib.net
 
# Preferred version:  
#     1.3.2     http://zlib.net/fossils/zlib-1.3.2.tar.gz
 
# Safe versions:  
#     1.3.2     http://zlib.net/fossils/zlib-1.3.2.tar.gz
#     1.3.1     http://zlib.net/fossils/zlib-1.3.1.tar.gz
#     1.3       http://zlib.net/fossils/zlib-1.3.tar.gz
#     1.2.13    http://zlib.net/fossils/zlib-1.2.13.tar.gz
 
# Deprecated versions:  
#     None
 
# Variants:
#     build_system [makefile]        generic, makefile
#         Build systems supported by the package
 
#     optimize [true]                false, true
#         Enable -O2 for a more optimized lib
 
#     pic [true]                     false, true
#         Produce position-independent code (for shared libs)
 
#     shared [true]                  false, true
#         Enables the build of shared libraries.
 
# Dependencies:
#     c            build
 
#     cxx          build
 
#     gmake        build
#       when  build_system=makefile
 
# Licenses:
#     Zlib
 
# Step 5: For a sense of accomplishment, try "spack install llvm" or "spack install gcc"
 
# Total elapsed time: 00:49 (MM:SS)

